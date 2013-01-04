require "instagram"

class InstagramController < ApplicationController 


CALLBACK_URL = "http://blendsocial.herokuapp.com/oauth/callback"

def new

end

def create

   redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  
end

def callback 
  @responsetype = 'code'
  puts params[:code].to_s
  puts CALLBACK_URL.to_s
  @code = params[:code]
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  puts response.inspect
  session[:access_token] = response.access_token
  redirect_to "/feed"
end


def feed
  client = Instagram.client(:access_token => session[:access_token])
  user = client.user

  @html = "<h1>#{user.username}'s recent photos</h1>"
  for media_item in client.user_recent_media
    @html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
   @user = client.user
    @recent_media_items = client.user_recent_media
  @html
end


def photos
  
end

end