class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :user_name ,:password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :authentications, :dependent => :delete_all
  
 def apply_omniauth(auth)
   puts auth.inspect
   self.email = auth['extra']['raw_info']['email']
   # Again, saving token is optional. If you haven't created the column in authentications table, this will fail
   authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
end


 
  

end
