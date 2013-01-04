Blendwith::Application.routes.draw do
 
  devise_for :users , :controllers => {:registrations => 'registrations', :omniauth_callbacks => "omniauth_callbacks" }
  
  resources:users
  resources:twitter
   resources:instagram
  resources:youtube
  resources:soundcloud
  resources:picasa
  resources :authentication
  resources :home
  match '/auth/:provider/callback' => 'authentication#create'
  match '/dashboard' => 'home#dashboard'
  
  resources:facebook
  
  match '/songs' => 'soundcloud#songs'
  match '/soundcloudupdate' => 'soundcloud#update1'
  
   match '/fbprofile' => 'facebook#profile'
    match '/fbphotos' => 'facebook#photos'
    match '/changestatus' => 'facebook#changestatus'
    match '/createalbum' => 'facebook#createalbum'
    match '/createphotos' => 'facebook#createphotos'
    match '/twsignin' => 'twitter#signin'
    match '/twprofile' => 'twitter#profile'
    match '/callback' => 'twitter#callback'
    match '/changetwstatus' => 'twitter#changetwstatus'
    match '/tweets' => 'twitter#tweets'
    match '/uploadyoutube' => 'youtube#upload'
     match '/uploadvideo' => 'youtube#uploadvideo'
     match '/deletevideo' => 'youtube#deletevideo'
    match '/picasaphotos' => 'picasa#photos'
    match '/picasacreatealbum' => 'picasa#createalbum'
    match '/piccreatephotos' => 'picasa#createphotos'
     match '/picalbumdelete' => 'picasa#deletealbum'
     match '/oauth/connect' => 'instagram#create'
      match '/oauth/callback' => 'instagram#callback'
         match '/instagram/photos' => 'instagram#photos'
           match '/feed' => 'instagram#feed'
       match '/' => 'home#index'
    devise_scope :user do
      get '/sign_in' => 'devise/sessions#new'
      get '/sign_out' => 'devise/sessions#destroy'
    end
 
 root :to => "home#index"
 
  
end
