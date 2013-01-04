require 'picasa'
require 'PicasaWebAlbums'
class PicasaController < ApplicationController 

 def new
   
  end
 
  
  def create
 
   
  $picasa = PicasaWebAlbums.get_repository( params[:name] ,  params[:password])
   session[:picname]= params[:name]
   session[:picpass]= params[:password]
  
  
   puts $picasa.inspect
   	 redirect_to '/picasaphotos'
    
  end
  
  def show
    @albums=$picasa.get_all_albums

   puts @albums.inspect
  end
  
  def photos
   
   if $picasa
       @albums=$picasa.get_all_albums
puts $picasa.get_photos_by_album_id(@albums[1].id).inspect
 end
    
  end
  
  def createalbum
  @album =  PicasaWebAlbums::Album.new
  @album.title= params[:album]
    $picasa.create_album(@album)
    redirect_to '/picasaphotos'
  end

  def createphotos
       picclient = Picasa::Client.new(:user_id =>  session[:picname], :password =>  session[:picpass])
        album_id = params['picphotoform']['albump'] 
         uploaded_io = params[:photo]
	  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
	    file.write(uploaded_io.read)
	  end
          picclient.photo.create(album_id,file_path:File.new("public/uploads/"+uploaded_io.original_filename)  )
        redirect_to '/picasaphotos'
         
  end
  
   def deletealbum
     $picasa.delete_album_by_id(params[:id])
     redirect_to '/picasaphotos'
   end
end