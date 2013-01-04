
class FacebookController < ApplicationController 


def profile
      @sessionfb=session[:fbprofile]
       puts session[:resttoken].to_s
      @rest = Koala::Facebook::API.new(session[:resttoken][0])
     
      @fbmessages = @rest.get_object("/me/statuses", "fields"=>"message")
     
end

def photos

  @rest = Koala::Facebook::API.new(session[:resttoken][0])
  @fbalbums= @rest.get_object("/me/albums","fields"=>"name,photos")
  
  
     
end

def changestatus

  @rest = Koala::Facebook::API.new(session[:resttoken][0])
 
  @rest.put_wall_post(params[:status])
  
   redirect_to '/fbprofile'
end

def createalbum

  @rest = Koala::Facebook::API.new(session[:resttoken][0])
 
  @rest.put_object('me','albums',:name => params[:album])
  
   redirect_to '/fbphotos'
end

def createphotos

  @rest = Koala::Facebook::API.new(session[:resttoken][0])

  album_id = params['photoform']['albump'] 
  
 puts "album id"+params.to_s
  #@rest.put_picture('http://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Rose_Amber_Flush_20070601.jpg/220px-Rose_Amber_Flush_20070601.jpg',{:message=>'This is the photo caption'},album_id)    
  @rest.put_picture(params[:photo],{:message=>'This is the photo caption'},album_id)
   redirect_to '/fbphotos'
end



end