class AuthenticationController < ApplicationController 

def index
    @authentications = current_user.authentication if current_user 
  end
  
 def create

  omniauth = request.env["omniauth.auth"]
          
  authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
  
  if authentication && authentication.user.present?
  puts "come start"
  @rest = Koala::Facebook::API.new(omniauth['credentials']['token'])

  @me= @rest.get_object("me")

   
   session[:fbprofile] ||= [] << @me
   session[:resttoken] ||= [] << omniauth['credentials']['token']
 

   flash[:notice] = "Signed in successfully."


   sign_in(:user, authentication.user)
   
   redirect_to dashboard_url
  

  elsif current_user
    puts "come current"
    current_user.authentication.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
    flash[:notice] = "Authentication successful."
    
    redirect_to dashboard_url
  else
    puts "come creates"
    user = User.new
    user.apply_omniauth(omniauth)
    
    if user.save
        sign_in_and_redirect(:user, user) 

 
  
    else
      session[:omniauth] = omniauth.except('extra')
      redirect_to dashboard_url
    end
  end
end

def destroy
    @authentication = current_user.authentication.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to "/"
  end
  
end
