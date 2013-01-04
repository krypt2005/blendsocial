require "instagram"

Instagram.configure do |config|
  config.client_id = "1398dbb5a9964177988766df244311ba"
  config.client_secret = "48e49c9151e04addb7f5b223d91e74af"
end

CALLBACK_URL = "http://blendsocial.herokuapp.com/oauth/callback"