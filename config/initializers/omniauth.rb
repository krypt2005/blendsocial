Rails.application.config.middleware.use OmniAuth::Builder do 
   provider :facebook, '249656908396518', 'ac10a48a9a864b14fec10b4b39b685a1',:scope => 'user_photos,user_videos,email,user_birthday,read_stream,publish_stream,user_location,user_birthday,user_status'
  
end