class User < ActiveRecord::Base
	has_secure_password
  attr_accessible :username, :password, :password_confirmation
  has_one :default_list, :class_name => 'Playlist'
  has_many :playlists, :class_name => 'Playlist'
  before_save :create_remember_token

  validates_uniqueness_of :username
  
  def lists
    self.playlists - [self.default_list]
  end

  private
  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end

  	def logged_in?
  		session[:remember_token]  == self.remember_token
  	end
end
