require 'sinatra'

require 'sinatra/reloader'
also_reload "models/post"
also_reload "models/user"
require "pg"
require_relative "models/post"
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

get '/overview' do
 
  erb :overview

end

get '/restaurants' do
 
  erb :restaurants

end

get '/workers' do
 
  erb :workers

end



# ===POSTS===


get '/post/new' do

  erb :new

end

get '/post/:id' do

  erb :new

end



get '/posts-front-of-house' do

  posts_FOH = find_posts_front_of_house
  
  erb :posts_front_of_house, locals: { posts_FOH: posts_FOH }

end

get '/posts-back-of-house' do

  posts_BOH = find_posts_back_of_house
  
  erb :posts_back_of_house, locals: { posts_BOH: posts_BOH }

end


get '/post/:id' do

  dish = find_one_dish_by_id(params["id"])

  erb :show, locals: { dish: dish }

end

post '/post' do

  return "get out of here" unless logged_in? # early return. guard  condition

  # create_dish(params["title"], params["image_url"], session["user_id"])
  # current_user checks the database, not the session
  create_dish(params["title"], params["image_url"], current_user["id"])

  redirect "/"

end


delete '/post/:id' do

  # params!!!

  destroy_dish(params["id"])

  redirect "/"

end

get '/post/:id/edit' do

  dish = find_one_dish_by_id(params["id"])

  erb :edit, locals: { dish: dish }

end

patch '/post/:id' do

  update_dish(params["id"], params["title"], params["image_url"])
  
  redirect "/post/#{params["id"]}"

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


