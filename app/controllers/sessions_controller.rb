class SessionsController < ApplicationController
  def new
  end
  def create
  	user = User.find_by_username(params[:username])
  	if !user.nil? && user.authenticate(params[:password])
		session[:remember_token] = user.remember_token
		redirect_to user, notice: "Login Successful"
  	else
  		# flash[:error] = 'Username and/or Password combination invalid.'
  		render 'new'
  	end
  end
  def destroy
  	session[:remember_token] = nil
  	redirect_to root_path
  end
end
