class ApplicationController < ActionController::Base
	before_filter :set_access_control_headers
	
	protect_from_forgery

	def set_access_control_headers
		#can i access the currentUser here?
		logger.ap current_user.username
	  headers['Access-Control-Allow-Origin'] = 'http://arnab-deka.com'
	  headers['Access-Control-Request-Method'] = 'POST, OPTIONS'
    headers['Access-Control-Expose-Headers'] = 'ETag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Allow-Headers'] = '*,X-CSRF-Token,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
    headers['Access-Control-Max-Age'] = '86400'
	end
	
  helper_method :current_user
	def current_user
	  @current_user ||= User.find_by_remember_token(session[:remember_token]) if session[:remember_token]
	end

		# def authorize
		#   redirect_to login_url, alert: "Not authorized" if current_user.nil?
		# end
end
