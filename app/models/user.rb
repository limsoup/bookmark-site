class User < ActiveRecord::Base
	has_secure_password
  attr_accessible :username, :password, :password_confirmation
  has_many :playlists
  before_save :create_remember_token

  validates_uniqueness_of :username

  private
  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end

  	def logged_in?
  		session[:remember_token]  == self.remember_token
  	end
end
