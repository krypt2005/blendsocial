require 'youtube_it'

class YoutubeController < ApplicationController 

 def new
   if $client
    # redirect_to '/youtube/show'
   end
  end
 
  
  def create
 
   puts params.inspect
   $client = YouTubeIt::Client.new(:username => params[:name], :password =>  params[:password],:dev_key => "AI39si4CntFK9zJGTO5d3OFyODcssDot9WpNOEZML7RwPVwrOGu-_XkvSccGbaw7Mm05K7db2zCzxdgWWb_kI8YPw7hqlsOrZw")
   
   @video= $client.my_videos
   	
   	 redirect_to '/youtube/show'
    
  end
  
  def show
  
  if $client
    @video= $client.my_videos
  
   	puts @video.inspect
   	
   	end
   	
  end
  
  def upload
  
   
  end
  
  
  def uploadvideo
  uploaded_io = params[:file]
	  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
	    file.write(uploaded_io.read)
	  end
   $client.video_upload(File.new("public/uploads/"+uploaded_io.original_filename), :title => params[:title],:description => 'some description')
   redirect_to  '/youtube/show'
  end
   
   def deletevideo
   
     $client.video_delete(params[:id])
     
     redirect_to  '/youtube/show'
   end
  end