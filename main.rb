require 'sinatra'
require 'sinatra/reloader'
also_reload "models/gigs"
also_reload "models/user"
require "pg"
require 'cloudinary'
require_relative "models/gigs"
require_relative "models/user"

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
  # returnds the current user record as a hash

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

  redirect "/"

  end

end


# ===READ===

get '/profile' do

  return "Please log in to access this content" unless logged_in?

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

  user = find_one_user_by_id(current_user["id"])

  erb :edit_profile, locals: { user: user }

end

config = {
  cloud_name: "dnyb6nnrp",
  api_key: ENV["CLOUDINARY_KEY"],
  api_secret: ENV["CLOUDINARY_SECRET"]
}

patch '/profile' do

  return erb :browse_gigs unless logged_in?

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

# ========================GIGS========================


get '/gigs/new-gig' do

  return erb :browse_gigs unless logged_in?

  erb :new_gig

end


get '/gigs-front-of-house' do

  gigs_foh = find_gigs_front_of_house
  
  erb :gigs_front_of_house, locals: { gigs_foh: gigs_foh }

end

get '/gigs-back-of-house' do

  gigs_boh = find_gigs_back_of_house
  
  erb :gigs_back_of_house, locals: { gigs_boh: gigs_boh }

end


get '/gigs/:id' do

  gig = find_one_gig_by_id(params["id"])

  erb :show, locals: { gig: gig }

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


delete '/gigs/:id' do

  delete_gig(params["id"])

  redirect "/"

end

get '/gigs/:id/edit' do

  gig = find_one_gig_by_id(params["id"])

  erb :edit_gig, locals: { gig: gig }

end

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


# ======================SESSION======================


get '/session/new' do

  erb :new_session

end

post '/session' do
  
  # find user by email

  user = find_one_user_by_email(params["email"])

  # check if password is correct

  if user && BCrypt::Password.new(user["password_digest"]) == params["password"]
    
    # creating a session

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


