source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'rack-ssl', :require => 'rack/ssl'


gem 'thin'
gem 'validates_existence', '>= 0.4' #i'm not sure i need this anymore. i should probably find out exactly what it does
gem "awesome_print" #will it work in heroku?
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'nokogiri'
gem 'imagesize'

group :development do
	gem 'sqlite3'
	gem 'quiet_assets'
	gem "haml"
end


# Gems used only for assets and not required
# in production environments by default.
group :production do
	gem 'ayah_integration'
	gem 'pg'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
	
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end


# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

#gem 'newrelic_rpm', :group => :production