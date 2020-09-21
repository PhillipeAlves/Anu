require 'sinatra'
require 'sinatra/reloader' if development?
also_reload "models/gigs" if development?
also_reload "models/user" if development?
also_reload "models/messages" if development?
require "pg"
require 'cloudinary'
require_relative "models/gigs"
require_relative "models/user"
require_relative "models/messages"

enable :sessions


# ===LOGIN===


def logged_in?
  if session["user_id"]
    true
  else
    false
  end
end

def current_user
  find_one_user_by_id(session["user_id"])
end


# ===HOMEPAGE===


get '/' do
  erb :index
end

get '/how-it-works' do
  erb :how_it_works
end

get '/browse-staff' do
  erb :browse_staff
end

get '/browse-gigs' do
  erb :browse_gigs
end


# ======================USERS========================


# ===Create===


get '/users/new' do
  erb :new_users
end

post '/users' do
  if params["email"] == "" || params["password"] == ""
    erb :new_users
  else
  create_user(params["email"], params["password"])
  redirect "/users/signed-up"
  end
end

get '/users/signed-up' do
  erb :signed_up
end

# ===READ===

get '/profile' do
  return redirect '/' unless logged_in?
  user = find_one_user_by_id(current_user["id"])
  erb :profile, locals: { user: user }
end

get '/profile/:id' do
  user = find_one_user_by_id(params["id"])
  erb :profile_view, locals: { user: user }
end

get '/workers-front-of-house' do
  foh = find_users_front_of_house
  erb :workers_front_of_house, locals: { foh: foh }
end

get '/workers-back-of-house' do
  boh = find_users_back_of_house
  erb :workers_back_of_house, locals: { boh: boh }
end

get '/browse-gigs' do
  erb :browse_gigs
end

# ===UPDATE===

get '/profile/:id/edit' do
  return redirect '/' unless logged_in?
  user = find_one_user_by_id(current_user["id"])
  erb :edit_profile, locals: { user: user }
end

config = {
  cloud_name: "dnyb6nnrp",
  api_key: ENV["CLOUDINARY_KEY"],
  api_secret: ENV["CLOUDINARY_SECRET"]
}

patch '/profile' do
  return redirect '/' unless logged_in?
  if params["position"] == "FOH"
    is_front_of_house = "t"
    is_back_of_house = "f"
  else
    is_front_of_house = "f"
    is_back_of_house = "t"
  end
  if params[:image_data]
    result = Cloudinary::Uploader.upload(params["image_data"]["tempfile"], config)
    image_data = result["url"]
  else
    image_data = find_one_user_by_id(current_user["id"])["image_data"]
  end
  update_user(current_user["id"], params["user_name"], params["bio"], params["skills"], image_data, is_front_of_house, is_back_of_house)
  redirect "/profile"
end

# ===DELETE===

delete '/profile/:id' do
  if logged_in? && (current_user["id"] == params["id"])
    if find_gigs_from_user(current_user["id"]) != "" 
      delete_gigs_from_user(current_user["id"])
    end
    delete_user(current_user["id"])
  end
  session["user_id"] = nil
  redirect '/profile-deleted'
end

get '/profile-deleted' do
  erb :profile_deleted
end


# ========================GIGS========================

# ===CREATE===

get '/gigs/new-gig' do
  return erb :browse_gigs unless logged_in?
  erb :new_gig
end

post '/gigs' do
  return erb :browse_gigs unless logged_in?
  if params["position"] == "FOH"
    is_front_of_house = "t"
    is_back_of_house = "f"
  else
    is_front_of_house = "f"
    is_back_of_house = "t"
  end
  create_gig(params["title"], params["description"], current_user["id"], params["calendar"], is_front_of_house, is_back_of_house)
  redirect "/browse-gigs"
end

# ===READ===

get '/gigs-front-of-house' do
  gigs_foh = find_gigs_front_of_house 
  erb :gigs_front_of_house, locals: { gigs_foh: gigs_foh }
end

get '/gigs-back-of-house' do
  gigs_boh = find_gigs_back_of_house 
  erb :gigs_back_of_house, locals: { gigs_boh: gigs_boh }
end

get '/gigs/:id/edit' do
  gig = find_one_gig_by_id(params["id"])
  erb :edit_gig, locals: { gig: gig }
end

# ===UPDATE===

patch '/gigs/:id' do
  return erb :browse_gigs unless logged_in?
  if params["position"] == "FOH"
    is_front_of_house = "t"
    is_back_of_house = "f"
  else
    is_front_of_house = "f"
    is_back_of_house = "t"
  end 
  update_gig(params["id"], params["title"], params["description"], params["calendar"], is_front_of_house, is_back_of_house)
  redirect "/"
end

# ===DELETE===

delete '/gigs/:id' do
  delete_gig(params["id"])
  redirect "/"
end


# =====================MESSAGES======================

# ===CREATE===

post '/profile/:id' do
  create_message(params["message"], current_user["id"], params["id"])
  redirect "/profile"
end

# ===READ===

get '/messages' do
  messages_to = find_messages_to_user(current_user["id"])
  messages_from = find_messages_from_user(current_user["id"])
  erb :view_messages, locals: { messages_to: messages_to, messages_from: messages_from }
end

# ======================SESSION======================


get '/session/new' do
  erb :new_session
end

post '/session' do 
  user = find_one_user_by_email(params["email"])
  if user && BCrypt::Password.new(user["password_digest"]) == params["password"]
    session["user_id"] = user["id"]
    redirect "/profile"
  else
    erb :new_session
  end

end

delete "/session" do
  session["user_id"] = nil
  redirect "/"
end


