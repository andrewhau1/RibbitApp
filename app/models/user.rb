class User < ActiveRecord::Base
	# attr_accessible :email, :name, :password, :password_confirmation, :username, :avatar_url
  	has_secure_password
	has_many :ribbits

	has_many :follower_relationships, class_name: "Relationship", foreign_key: "followed_id"
	has_many :followed_relationships, class_name: "Relationship", foreign_key: "follower_id"

	has_many :followers, through: :follower_relationships
	has_many :followeds, through: :followed_relationships
	
	before_validation :prep_email
	before_save :create_avatar_url

	validates :name, presence: true
	validates :username, uniqueness: true, presence: true
	validates :email, uniqueness: true, presence: true, format: { with: /\A[\w.+-]+@([\w]+.)+\w+\z/ }

	def following? user
		self.followeds.include? user
	end

	def follow user
		Relationship.create follower_id: self.id, followed_id: user_id
	end
	
	private
	def prep_email
	    self.email = self.email.strip.downcase if self.email
	end
	
	def create_avatar_url
    	self.avatar_url = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}?s=50"
	end
end
