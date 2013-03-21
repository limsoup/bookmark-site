class UsersController < ApplicationController
	before_filter :logged_in, :except => [:new, :create]
	before_filter :authorize, :only => [:edit, :update]
	before_filter :authorize_or_accessible, :only => [:show]
	before_filter :authorize_admin, :only => [:index]

	def new
		if flash[:user]
			@user = flash[:user]
		else
			@user = User.new
		end
		# ayah = AYAH::Integration.new('bd04599eed9a3768e786ecbf73defecc313a59b1', '08dc9c32c3d7426be6aebb66b7cff9958b4d9c27')
		# @publisher_html = ayah.get_publisher_html
		if request.xhr?
			render :partial => 'modal_new'
		else
			render 'new'
		end
	end

	def create
		@user = User.new(params[:user])
		session_secret = params['session_secret'] # in this case, using Rails
		# ayah = AYAH::Integration.new('bd04599eed9a3768e786ecbf73defecc313a59b1', '08dc9c32c3d7426be6aebb66b7cff9958b4d9c27')
		# ayah_passed = ayah.score_result(session_secret, request.remote_ip)
		# if ayah_passed
			@user.admin = false
			@user.human = true
			if(@user.save)
				session[:remember_token] = @user.remember_token
				@user.default_list = Playlist.create(:playlist_name => "default list")
				respond_to do |format|
					format.html { redirect_to user_path(@user), :notice => "You've signed up successfully." }
					format.json { render :json => {"success" => "true" } }
				end
			else
				respond_to do |format|
					format.html { 
						flash[:user] = @user
						redirect_to signup_path
					}
					format.json { render :json =>{ "errors" => @user.errors.full_messages }}
				end
			end
		# else
			# respond_to do |format|
			# 	format.html { render 'new', :notice => "You didn't successfully prove you're human." }
			# 	format.json { render :json =>{ "errors" => ["You didn't successfully prove you're human."] } }
			# end
		# end
	end

	# def upgrade
	# 	if current_user.nil?
	# 		render :partial => 'error' #message about how they need cookies enabled
	# 	else
	# 		@user = current_user
	# 		ayah = AYAH::Integration.new('bd04599eed9a3768e786ecbf73defecc313a59b1', '08dc9c32c3d7426be6aebb66b7cff9958b4d9c27')
	# 		@publisher_html = ayah.get_publisher_html
	# 		render :partial => 'modal_upgrade'
	# 		# if @user.human?
	# 		# 	render :partial => 'edit'
	# 		# else
	# 		# 	render :partial => 'modal_new'
	# 		# end
	# 	end
	# end

	def update
		@user = User.find(params[:id])
		# if !(@user.human)
		# 	session_secret = params['session_secret'] # in this case, using Rails
		# 	ayah = AYAH::Integration.new('bd04599eed9a3768e786ecbf73defecc313a59b1', '08dc9c32c3d7426be6aebb66b7cff9958b4d9c27')
		# 	ayah_passed = ayah.score_result(session_secret, request.remote_ip)
		# end
		# if @user.human or ayah_passed
			@user.update_attributes(params[:user])
			if(!params[:user][:password].blank?)
				@user.password = params[:user][:password]
			end
			if(!params[:user][:username].blank?)
				@user.username = params[:user][:username]
			end
			# @user.human = true
			if(@user.save)
				respond_to do |format|
					format.html { redirect_to user_path(@user), :notice => "You've signed up successfully." }
					format.json { render :json => {"success" => "true" } }
				end
			else
				respond_to do |format|
					# format.html { render edit_user_path(@user), :notice => "You had some errors with your changes." }
					# @user = User.find(params[])
					format.html { 
						flash[:user] = @user
						redirect_to edit_user_path(@user)
					}
					format.json { render :json =>{ "errors" => @user.errors.full_messages }}
				end
			end
		# else
		# 	respond_to do |format|
		# 		format.html { render 'edit', :notice => "You didn't successfully prove you're human." }
		# 		format.json { render :json =>{ "errors" => ["You didn't successfully prove you're human."] } }
		# 	end
		# end
	end

	def edit
		if(flash[:user])
			@user = flash[:user]
		else
			@user = User.find(params[:id])
		end
		# if(!@user.human)
		# 	ayah = AYAH::Integration.new('bd04599eed9a3768e786ecbf73defecc313a59b1', '08dc9c32c3d7426be6aebb66b7cff9958b4d9c27')
		# 	@publisher_html = ayah.get_publisher_html
		# end
		if request.xhr?
			render :partial => 'modal_edit'
		else
			render 'edit'
		end
	end

	# def update
	# 	@user = User.find(params[:id])
	# 	@user.update_attributes(params[:user])
	# 	if(@user.save)
	# 		redirect_to users_path(@user), :notice => "You've signed up successfully."
	# 	else
	# 		render 'edit'
	# 	end
	# end

	def show
		# if(params[:id])
		# 	@user = User.find(params[:id])
		# else
		# 	@user = User.find_by_regularized_username(params[:username].gsub(/\s/,'').downcase)
		# 	# logger.ap @user
		# 	if @user.nil?
		# 		# logger.ap 'dammit'
		# 		redirect_to usernotfound_path
		# 	end
		# end
		# if @user
			logger.ap session
			@playlist = @user.default_list
			@lists = @user.lists
			# for modal new bookmark
			@user_bookmark = @playlist.user_bookmarks.build
			@bookmark_url = BookmarkUrl.new
		# end
	end

	def index
		@users = User.all
	end

	private
		def logged_in
			if(current_user.nil?)
				redirect_to login_path, :notice => "You have to log in to do that."
			end
		end

		def authorize
			redirect_to login_path, :notice => "You have to log in as that user to do that." unless ((current_user.id.to_s == params[:id]) or current_user.admin)
		end
		
		def authorize_or_accessible
			if params[:id]
				@user = User.find(params[:id])
			elsif params[:username]
				@user = User.find_by_regularized_username(params[:username].gsub(/\s/,'').downcase)
			end
			if @user
				redirect_to login_path, :notice => "You have to log in as that user to do that." unless ((current_user.id.to_s == params[:id]) or current_user.admin or @user.access)
			else
				redirect_to usernotfound_path
			end
		end

		def authorize_admin
			redirect_to login_path, :notice => "You have to be an admin access that." unless (current_user.admin)
		end

end
