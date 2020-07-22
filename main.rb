require 'sinatra'

require 'sinatra/reloader'
also_reload "models/gigs"
also_reload "models/user"
require "pg"
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


get '/users/new' do

  erb :new_users

end

post '/users' do

  if params["user_name"] == "" && params["email"] == "" && params["password"] == ""
  
    error = "All fields must be filled"

    erb :users, locals: { error: error }
  
  else

  create_user(params["user_name"], params["email"], params["password"])

  end

  redirect"/"

end

get '/users' do

  erb :users

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

  redirect "/"

end


delete '/gigs/:id' do

  # params!!!

  destroy_dish(params["id"])

  redirect "/"

end

get '/gigs/:id/edit' do

  dish = find_one_dish_by_id(params["id"])

  erb :edit, locals: { dish: dish }

end

patch '/gigs/:id' do

  update_dish(params["id"], params["title"], params["image_url"])
  
  redirect "/gigs/#{params["id"]}"

end


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

    redirect"/"
  else
    erb :new_session
  end

end

delete "/session" do

  session["user_id"] = nil

  redirect "/"

end


