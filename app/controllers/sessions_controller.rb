class SessionsController < ApplicationController
  def new
    #flash = flash
  end
  def create
  	user = User.find_by_username(params[:username])
  	if !user.nil? && user.authenticate(params[:password])
  		session[:remember_token] = user.remember_token
  		redirect_to username_path(user), notice: "Login Successful"
  	else
  		flash[:login_error] = 'Username / Password combination invalid.'
  		redirect_to login_path
  	end
  end
  def destroy
  	session[:remember_token] = nil
    session[:logged_out] = true;
  	redirect_to root_path
  end
end
