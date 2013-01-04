require 'twitter'

class TwitterController < ApplicationController 

   def new
    puts client.inspect
    @user = client.user if signed_in?
  end

  def create
   @oauth_consumer ||= OAuth::Consumer.new('fVGrZmGe99AuKwE4HMLC1A', 'T3zyjeQzujkC3k2IVyvTdqnt4eK4ZcA3y5Tr2RTc', :site => 'http://api.twitter.com', :request_endpoint => 'http://api.twitter.com', :sign_in => true)
    request_token = @oauth_consumer.get_request_token(:oauth_callback => callback_url)
    session['request_token'] = request_token.token
    session['request_secret'] = request_token.secret
    redirect_to request_token.authorize_url
  end



  def callback
   @oauth_consumer ||= OAuth::Consumer.new('fVGrZmGe99AuKwE4HMLC1A', 'T3zyjeQzujkC3k2IVyvTdqnt4eK4ZcA3y5Tr2RTc', :site => 'http://api.twitter.com', :request_endpoint => 'http://api.twitter.com', :sign_in => true)
    request_token = OAuth::RequestToken.new(@oauth_consumer, session['request_token'], session['request_secret'])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    #session['tw_token'] = access_token
    session['access_token'] = access_token.token
    session['access_secret'] = access_token.secret
    user = client.verify_credentials
    puts user.inspect
    session[:twprofile] ||= [] << user
    
    authentication = Authentication.find_by_provider_and_uid('twitter', user['id'].to_s)
  
  if authentication && authentication.user.present?
  puts "come auth"+authentication.user.inspect
   # sign_in(:user, authentication.user)
      sign_in authentication.user
  #puts "after session " + session.inspect
    redirect_to '/twprofile'
    #redirect_to '/twprofile'
   # elsif current_user
    #puts "come current"
    #current_user.authentication.create!(:provider => 'twitter', :uid => user['id'])
    #flash[:notice] = "Authentication successful."
    
    #redirect_to '/twprofile'
  else
    puts "come creates"
    
  @user=User.new(:user_name =>user['screen_name'], :email => user['screen_name']+'@twitter.com' , :password => Devise.friendly_token[0,10])
   
    @user.save
    
   @authen=Authentication.new(:provider => 'twitter', :uid => user['id'],:user_id => @user.id , :token => session['access_token'])
   @authen.save
   
 #  puts "before session " + session.inspect
  
  sign_in @user
  #puts "after session " + session.inspect
    redirect_to '/twprofile'

    end
  
  end
  
  
  
  def profile
  
   @user=session[:twprofile]
   @status=client.user.status
  # puts "uerr---"+@user.to_s
     
  end

   def signin 
		 
	end
	
	def tweets
	 @tweets = client.user_timeline(client.user.id)
	 #puts @tweets.inspect
	# puts client.user.id.inspect
	end
	
	def changetwstatus
	if (!params[:photo].present?)
	client.update(params[:status])
	else
	 #client.post("https://upload.twitter.com/1/statuses/update_with_media.json‌",:status => "stat",:media => params[:status] , 'Content-Type' =>  'multipart/form-data')
	 #client.update_with_media(:status =>  params[:status],:media => params[:photo])
	  
	  uploaded_io = params[:photo]
	  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
	    file.write(uploaded_io.read)
	  end
	  client.update_with_media(params[:status], File.new("public/uploads/"+uploaded_io.original_filename))
	  
	  datafile = params[:photo]
	 # puts datafile.inspect
      #client.update_with_media("File upload from Skype: ", datafile)
      @oauth_consumer ||= OAuth::Consumer.new('fVGrZmGe99AuKwE4HMLC1A', 'T3zyjeQzujkC3k2IVyvTdqnt4eK4ZcA3y5Tr2RTc', :site => 'http://api.twitter.com', :request_endpoint => 'http://api.twitter.com', :sign_in => true)
      token_hash = { :oauth_token => session['access_token'],
                 :oauth_token_secret => session['access_secret']
               }
     access_token = OAuth::AccessToken.from_hash(@oauth_consumer , token_hash )
    # @response=client.update_with_media("File upload from Skype: ", datafile)
     @response=access_token.request(:post,  "https://upload.twitter.com/i/tweet/create_with_media.iframe"  , :media => datafile , :status  => params[:status])
      
      end
      puts @response.inspect
	 redirect_to '/tweets'
	end

end
