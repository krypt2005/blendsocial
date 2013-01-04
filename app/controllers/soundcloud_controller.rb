require 'soundcloud'
class SoundcloudController < ApplicationController
 
def new

end

def create
 $soundcloud_client = Soundcloud.new({
  :client_id      => 'fdd51cf3cc3b9efb7524de60d307ea9a',
  :client_secret  => '1804d177014229781c43e5bb7148d2d3',
  :username       => params[:name],
  :password       => params[:password]
})

 puts $soundcloud_client.inspect
  redirect_to '/songs'

end

def songs
@tracks = $soundcloud_client.get("/me/tracks", :limit => 5)
 @me = $soundcloud_client.get("/me")
end
  
def update1
    res = $soundcloud_client.put("/me", :user => {:description => params[:description],:username => params[:username]})
   redirect_to '/songs'
end

end