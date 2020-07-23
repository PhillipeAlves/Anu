require 'sinatra'
require 'sinatra/reloader'
also_reload "models/gigs"
also_reload "models/user"
require "pg"
require 'cloudinary'
require_relative "models/gigs"
require_relative "models/user"
require "URI"

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

  if params["email"] == "" && params["password"] == ""

    redirect "/users/new", 303
  
  else

  create_user(params["email"], params["password"])

  end

  redirect "/"

end


# ===READ===

get '/profile' do

  return "Please log in to access this content" unless logged_in?

  user = find_one_user_by_id(current_user["id"])

  erb :profile, locals: { user: user }

end

get '/users' do

  erb :users

end

get '/workers-front-of-house' do

  foh = find_users_front_of_house

  erb :workers_front_of_house, locals: { foh: foh }

end

get '/workers-back-of-house' do

  boh = find_users_back_of_house

  erb :workers_back_of_house, locals: { boh: boh }

end


# ===UPDATE===

get '/profile/edit' do

  user = find_one_user_by_id(current_user["id"])

  erb :edit_profile, locals: { user: user }

end

config = {
  cloud_name: "dnyb6nnrp",
  api_key: ENV["CLOUDINARY_KEY"],
  api_secret: ENV["CLOUDINARY_SECRET"]
}

patch '/profile' do

  params["position"]

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


get '/gigs/new' do

  erb :new

end

get '/gigs/:id' do

  erb :new

end



get '/gigs-front-of-house' do

  gigs_FOH = find_gigs_front_of_house
  
  erb :gigs_front_of_house, locals: { gigs_FOH: gigs_FOH }

end

get '/gigs-back-of-house' do

  gigs_BOH = find_gigs_back_of_house
  
  erb :gigs_back_of_house, locals: { gigs_BOH: gigs_BOH }

end


get '/gigs/:id' do

  dish = find_one_dish_by_id(params["id"])

  erb :show, locals: { dish: dish }

end

post '/gigs' do

  return "get out of here" unless logged_in? # early return. guard  condition

  # create_dish(params["title"], params["image_url"], session["user_id"])
  # current_user checks the database, not the session
  create_dish(params["title"], params["image_url"], current_user["id"])

  create_gig(params["title"], params["description"], params["user_id"], params["is_front_of_house"],params["is_back_of_house"])

  redirect "/"

end


delete '/gigs/:id' do

  delete_dish(params["id"])

  redirect "/"

end

get '/gigs/:id/edit' do

  gig = find_one_gig_by_id(params["id"])

  erb :edit, locals: { gig: gig }

end

patch '/gigs/:id' do

  update_gig(params["id"], params["title"], params["is_front_of_house"], params["is_back_of_house"])
  
  redirect "/gigs/#{params["id"]}"

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


