class User < ActiveRecord::Base
	# attr_accessible :email, :name, :password, :password_confirmation, :username, :avatar_url
  	has_secure_password
	
	before_validation :prep_email
	before_save :create_avatar_url

	validates :name, presence: true
	validates :username, uniqueness:true, presence: true
	validates :email, uniqueness: true, presence: true, format: { with: /\A[\w.+-]+@([\w]+.)+\w+\z/ }

	has_many :ribbits

	
	private
	def prep_email
	    self.email = self.email.strip.downcase if self.email
	end
	
	def create_avatar_url
    	self.avatar_url = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}?s=50"
	end
end
