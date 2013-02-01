class UsersController < ApplicationController
	def new
		@user = User.new
	end
	def create
		@user = User.new(params[:user])
		if(@user.save)
			session[:remember_token] = @user.remember_token
			redirect_to users_path(@user), :notice => "You've signed up successfully."
		else
			render 'new'
		end
	end
	def show
		@user = User.find(params[:id])
		@playlists = @user.playlists
	end
	def index
		@users = User.all
	end
end
