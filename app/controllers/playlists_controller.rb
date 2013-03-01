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
		@playlist = current_user.playlists.find(params[:id])
	end

	def edit
		@playlist = current_user.playlists.find(params[:id])
		@lists = current_user.lists
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
		@lists = current_user.lists 
	end
	
	def destroy
		@playlist = current_user.lists.find(params[:id])
		users_list_ids = current_user.lists.pluck(:id)
		@playlist.user_bookmarks.each do |ub|
			other_playlists_with_url = UserBookmark.find_all_by_bookmark_url_id(ub.bookmark_url_id).pluck(:playlist_id)
			if (users_list_ids & other_playlists_with_url).empty?	#later, I should write a function that aborts as soon as a match is found
				current_user.default_list.user_bookmarks << ub;
			else
				ub.delete
			end
		end
		@playlist.delete
	end

	def destroy_with_contents
		@playlist = current_user.lists.find(params[:id])
		@playlist.user_bookmarks.each {|ub| ub.delete }
		@playlist.delete
	end

	private
		def authorize_owner
			@user = current_user
			playlist = @user.playlists.find(params[:id])
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
