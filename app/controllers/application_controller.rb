class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
	def current_user
	  @current_user ||= User.find_by_remember_token(session[:remember_token]) if session[:remember_token]
	end

		# def authorize
		#   redirect_to login_url, alert: "Not authorized" if current_user.nil?
		# end
end
