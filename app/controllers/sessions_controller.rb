class SessionsController < ApplicationController
  before_filter :instant_account_cleanup, :only => [:create,:destroy] 

  def new
  end

  def create
  	user = User.find_by_regularized_username(params[:username].gsub(/\s/,'').downcase)
  	if !user.nil? &&  (user.password_digest.nil? or user.authenticate(params[:password]))
  		session[:remember_token] = user.remember_token
      redirect_to username_path(user), notice: "Login Successful"
  	else
      flash[:login_error] = 'Username / Password combination invalid.'
      redirect_to login_path
  	end
  end

  def destroy
  	session[:remember_token] = nil
    session[:logged_out] = true
  	redirect_to root_path
  end

  private

    def instant_account_cleanup
      if flash[:instant_account]
        current_user.delete
        session[:remember_token] = nil
        flash[:instant_account] = nil
      end
    end
end
