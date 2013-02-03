class PlaylistsController < ApplicationController
	before_filter :authorize_owner, :only => [:edit, :update, :delete]
	before_filter :authorize, :only => [:new, :create]
	
	def new
		@playlist = current_user.playlists.build
	end

	def create
		@playlist = current_user.playlists.build(params[:playlist])
		if(@playlist.save)
			redirect_to @playlist, :notice => "Playlist Created Successfully"
		else
			render 'new'
		end
	end

	def show
		@playlist = Playlist.find(params[:id])
	end

	def edit
		@playlist = current_user.playlists.find(params[:id])
	end
	
	def update
		@playlist = current_user.playlists.find(params[:id])
		@playlist.update_attributes(params[:playlist])
		respond_to do |format|
			format.html {
		    if @playlist.save
		      redirect_to @playlist, notice: "Successfully updated playlist."
		    else
		      render 'edit'
		    end
		  }
		  format.js {
		  	render :nothing => true
		  }
		end
	end

	def index
		@playlists = Playlist.all
	end
	
	private
		def authorize_owner
			@user = current_user
			playlist = Playlist.find(params[:id])
			if(@user.nil?)
				redirect_to login_path, :notice => "You have to be logged in as the owner of the playlist to access this funcationality"
			else
				if(playlist.user_id != @user.id)
					redirect_to playlists_path
				end
			end
		end

		def authorize
			@user = current_user
			if(@user.nil?)
				redirect_to login_path, :notice => "you have to log in to make a playlist"
			end
		end
end
