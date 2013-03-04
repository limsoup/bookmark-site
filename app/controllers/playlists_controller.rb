class PlaylistsController < ApplicationController
	before_filter :authorize_owner, :only => [:edit, :update, :delete ]
	before_filter :authorize_show_playlist, :only => [:show]
	before_filter :authorize, :only => [:new, :create, :index]
	
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
		@lists = current_user.lists
		@user_bookmark = @playlist.user_bookmarks.build
		@bookmark_url = BookmarkUrl.new 	#this is because i'm doing the 'new' form differently
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
			if(current_user.nil?)
				redirect_to login_path, :notice => "You have to be logged in as the owner of that playlist to access this funcationality."
			end
			playlist = current_user.playlists.find_by_id(params[:id])
			if (playlist.nil?)
				redirect_to current_user, :notice => "You have to be logged in as the owner of that playlist to access this funcationality."
			end
		end

		def authorize
			if(current_user.nil?)
				redirect_to login_path, :notice => "You have to log in to make a playlist."
			end
		end

		def authorize_show_playlist
			if !(Playlist.find(params[:id]).public)
				if(current_user.nil?)
					redirect_to login_path, :notice => "You have to be logged in as the owner of that playlist to see it."
				end
				playlist = current_user.playlists.find_by_id(params[:id])
				if (playlist.nil?)
					redirect_to current_user, :notice => "You have to be logged in as the owner of that playlist to see it."
				end
			end
		end
end
