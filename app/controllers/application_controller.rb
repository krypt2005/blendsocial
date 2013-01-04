require 'twitter'
class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from Twitter::Error::Unauthorized, :with => :force_sign_in
  rescue_from Twitter::Error::TooManyRequests, :with => :rate_limit
  helper_method :current_user
  
  private
  def current_user
  if session["warden.user.user.key"]
	  userid=session["warden.user.user.key"][1]
	  @current_user ||= User.find(userid) if userid
  end
end



  def oauth_consumer
    @oauth_consumer ||= OAuth::Consumer.new('fVGrZmGe99AuKwE4HMLC1A', 'T3zyjeQzujkC3k2IVyvTdqnt4eK4ZcA3y5Tr2RTc', :site => 'http://api.twitter.com', :request_endpoint => 'http://api.twitter.com', :sign_in => true)
puts @oauth_consumer.to_s
  end

  def client
    Twitter.configure do |config|
      config.consumer_key = 'fVGrZmGe99AuKwE4HMLC1A'
      config.consumer_secret = 'T3zyjeQzujkC3k2IVyvTdqnt4eK4ZcA3y5Tr2RTc'
      config.oauth_token = session['access_token']
      config.oauth_token_secret = session['access_secret']
    end
    puts session['access_token'].to_s
    @client ||= Twitter::Client.new
  end
  helper_method :client

  def force_sign_in(exception)
    reset_session
    flash[:error] = "It seems your credentials are not good anymore. Please sign in again."
    redirect_to '/twitter/new'
  end
  
  def rate_limit

   reset_session
  flash[:error] = "It seems you have exceded the requests to Twitter , Please Wait for a minute and try."
  redirect_to '/twsignin'
 
  end 
end
