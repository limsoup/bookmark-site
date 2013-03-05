class UsersController < ApplicationController
	def new
		@user = User.new
		ayah = AYAH::Integration.new('bd04599eed9a3768e786ecbf73defecc313a59b1', '08dc9c32c3d7426be6aebb66b7cff9958b4d9c27')
		@publisher_html = ayah.get_publisher_html
		if request.xhr?
			render :partial => 'modal_new'
		else
			render 'new'
		end
	end

	def create
		@user = User.new(params[:user])
		if(@user.save)
			session[:remember_token] = @user.remember_token
			@user.default_list = Playlist.create(:playlist_name => "default list")
			respond_to do |format|
				format.html { redirect_to users_path(@user), :notice => "You've signed up successfully." }
				format.json { render :json => {"success" => "true" } }
			end
		else
			respond_to do |format|
				format.html { render 'new', :notice => "You've signed up successfully." }
				format.json { render :json =>{ "errors" => @user.errors.full_messages }}
			end
		end
	end

	def upgrade
		if current_user.nil?
			render :partial => 'error' #message about how they need cookies enabled
		else
			@user = current_user
			ayah = AYAH::Integration.new('bd04599eed9a3768e786ecbf73defecc313a59b1', '08dc9c32c3d7426be6aebb66b7cff9958b4d9c27')
			@publisher_html = ayah.get_publisher_html
			render :partial => 'modal_upgrade'
			# if @user.human?
			# 	render :partial => 'edit'
			# else
			# 	render :partial => 'modal_new'
			# end
		end
	end

	def process_upgrade
		session_secret = params['session_secret'] # in this case, using Rails
		ayah = AYAH::Integration.new('bd04599eed9a3768e786ecbf73defecc313a59b1', '08dc9c32c3d7426be6aebb66b7cff9958b4d9c27')
		ayah_passed = ayah.score_result(session_secret, request.remote_ip)
		if(ayah_passed)
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
					format.html { redirect_to users_path(@user), :notice => "You had some errors with your changes." }
					format.json { render :json =>{ "errors" => @user.errors.full_messages }}
				end
			end
		else
			respond_to do |format|
				format.html { redirect_to users_path(@user), :notice => "You didn't successfully prove you're human." }
				format.json { render :json =>{ "errors" => "You didn't successfully prove you're human." }}
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
			redirect_to users_path(@user), :notice => "Your changes will be saved as long as you don't delete your cookies."
		else
			logger.ap @user.errors.full_messages
			render 'temp'
		end
	end

	def show
		if(params[:id])
			@user = User.find(params[:id])
		else
			@user = User.find_by_username(params[:username])
			# logger.ap @user
			if @user.nil?
				# logger.ap 'dammit'
				redirect_to usernotfound_path
			end
		end
		if @user
			@playlist = @user.default_list
			@lists = @user.lists
			# for modal new bookmark
			@user_bookmark = @playlist.user_bookmarks.build
			@bookmark_url = BookmarkUrl.new
		end
	end

	def index
		@users = User.all
	end
end
