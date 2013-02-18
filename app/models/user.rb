class User < ActiveRecord::Base
  require 'bcrypt'
  
  attr_accessible :username, :password, :password_confirmation, :bookmarklet_user_key
  # has_secure_password :validations => false
  has_one :default_list, :class_name => 'Playlist'
  has_many :playlists, :class_name => 'Playlist'
  before_save :create_remember_token
  
  attr_accessor :password

  validates_presence_of :password_digest, :unless => :temp_user
  validates_confirmation_of :password, :unless => :temp_user
  validates_uniqueness_of :username, :unless => :temp_user
  
  #-- from secure_password.rb --
  if respond_to?(:attributes_protected_by_default)
    def self.attributes_protected_by_default
      super + ['password_digest']
    end
  end

  def authenticate(unencrypted_password)
    if BCrypt::Password.new(password_digest) == unencrypted_password
      self
    else
      false
    end
  end

  # Encrypts the password into the password_digest attribute.
  def password=(unencrypted_password)
    @password = unencrypted_password
    unless unencrypted_password.blank?
      self.password_digest = BCrypt::Password.create(unencrypted_password)
    end
  end
  
  #--- done with things from secure_password.rb


  def lists
    self.playlists - [self.default_list]
  end

  def reset_bookmarklet_user_key
    self.bookmarklet_user_key = SecureRandom.urlsafe_base64
  end
    
  private
    def temp_user
      self.password.nil? and self.username.nil?
    end

  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64 if self.remember_token.blank?
  	end

  	def logged_in?
  		session[:remember_token]  == self.remember_token
  	end
end
