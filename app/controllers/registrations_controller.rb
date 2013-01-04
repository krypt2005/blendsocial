class RegistrationsController < Devise::RegistrationsController
  def create
    #super
   
    @user = User.new(:user_name =>params[:user][:user_name], :email => params[:user][:email] , :password => Devise.friendly_token[0,10],:confirmation_token => Devise.friendly_token[0,10])
   
    if @user.save
    @user.send_reset_password_instructions

        flash[:notice] = "Signed Up successfully."
        sign_in_and_redirect(:user, @user)
    end
    session[:omniauth] = nil unless @user.new_record?
  end
  
  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])

      @user.valid?
      # puts "coming here"+@user.to_s
      #@user.confirm!
    end
  end
end
