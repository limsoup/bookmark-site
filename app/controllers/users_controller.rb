class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if(@user.save)
			session[:remember_token] = @user.remember_token
			@user.default_list = Playlist.create(:playlist_name => "default list")
			redirect_to users_path(@user), :notice => "You've signed up successfully."
		else
			render 'new'
		end
	end

	def upgrade
		if current_user.nil?
			render :partial => 'error' #message about how they need cookies enabled
		else
			@user = current_user
			render :partial => 'modal_new'
			# if @user.human?
			# 	render :partial => 'edit'
			# else
			# 	render :partial => 'modal_new'
			# end
		end
	end

	def process_upgrade
		@user = User.find(params[:id])
		@user.update_attributes(params[:user])
		@user.human = true
		if(@user.save)
			respond_to do |format|
				format.html { redirect_to users_path(@user), :notice => "You've signed up successfully." }
				format.json { render :json => {"success" => "true" } }
			end
		else
			respond_to do |format|
				format.html { redirect_to users_path(@user), :notice => "You've signed up successfully." }
				format.json { render :json =>{ "errors" => @user.errors.full_messages }}
			end
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		@user.update_attributes(params[:user])
		if(@user.save)
			redirect_to users_path(@user), :notice => "You've signed up successfully."
		else
			render 'edit'
		end
	end

	def temp
	end

	def create_temp
		@user = User.new
		logger.ap 'in create_temp'
		if(@user.save)
			session[:remember_token] = @user.remember_token
			@user.default_list = Playlist.create(:playlist_name => "default list")
			redirect_to users_path(@user), :notice => "Your changes will be saved as long as you don't delete your cookies"
		else
			logger.ap @user.errors.full_messages
			render 'temp'
		end
	end

	def show
		@user = User.find(params[:id])
		@playlist = @user.default_list
		@lists = @user.lists
		# for modal new bookmark
		@user_bookmark = @playlist.user_bookmarks.build
		@bookmark_url = BookmarkUrl.new
	end

	def index
		@users = User.all
	end
end
