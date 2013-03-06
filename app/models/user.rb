class User < ActiveRecord::Base
  require 'bcrypt'
  
  attr_accessible :username, :password, :bookmarklet_user_key
  #check if proved-human needs to be accessible
  #has_secure_password :validations => false
  has_one :default_list, :class_name => 'Playlist'
  has_many :playlists, :class_name => 'Playlist'
  before_save :create_remember_token, :reset_bookmarklet_user_key
  
  attr_accessor :password

  validates_presence_of :password_digest, :if => :human?
  #validates_confirmation_of :password, :if => :human?
  validates_uniqueness_of :username, :if => :human?
  validates :username, :length => {:in => 3..30}
  validates :password, :length => {:in => 3..30}
  
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

  def human?
    self.human
  end
  
  private

  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64 if self.remember_token.blank?
  	end

  	def logged_in?
  		session[:remember_token]  == self.remember_token
  	end
end
