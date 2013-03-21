class User < ActiveRecord::Base
  require 'bcrypt'
  
  attr_accessible :username, :regularized_username, :password, :access, :bookmarklet_user_key
  #check if proved-human needs to be accessible
  #has_secure_password :validations => false
  has_one :default_list, :class_name => 'Playlist'
  has_many :playlists, :class_name => 'Playlist'
  before_save :create_remember_token, :reset_bookmarklet_user_key
  before_validation :create_regularized_username
  attr_accessor :password

  validates_presence_of :password_digest, :unless => "password.blank?"
  #validates_confirmation_of :password, :if => :human?
  validates_uniqueness_of :regularized_username, :message => " has already been registered"
  validate :username_is_not_a_route
  # validates_format_of :username
  # validate :password, :length => {:in => 3..30}
  
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
  def purge_self
    if !(self.human?) and self.default_list.user_bookmarks.empty? and self.playlists.count == 1 and self.updated_at == self.created_at
      self.default_list.destroy
      self.destroy
    end
  end

  def lists
    self.playlists - [self.default_list]
  end

  def reset_bookmarklet_user_key
    self.bookmarklet_user_key = SecureRandom.urlsafe_base64
  end

  def human?
    self.human
  end
  
  protected
    def username_is_not_a_route
      path = Rails.application.routes.recognize_path("/#{regularized_username}" ) rescue nil
      if path && !path[:username]
        errors.add(:username, ": \"#{username}\" conflicts with the site's routing") 
      else
        path = Rails.application.routes.recognize_path("/#{username}") rescue nil
        if path && !path[:username]
          errors.add(:username, ": \"#{username}\" conflicts with the site's routing") 
        end
      end
    end

    def create_regularized_username
      self.regularized_username = self.username.gsub(/\s/,'').downcase
    end

  private

  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64 if self.remember_token.blank?
  	end

  	def logged_in?
  		session[:remember_token]  == self.remember_token
  	end
end
