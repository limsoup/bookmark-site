class UserBookmarksController < ApplicationController
	def new
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.build
		@bookmark_url = BookmarkUrl.new 	#this is because i'm doing the 'new' form differently
	end

	def create
		logger.ap params
		@playlist = current_user.playlists.find params[:playlist_id]
		# if no url is given, 
		if(!params[:user_bookmark][:bookmark_url_attributes][:url].nil?)
			@bookmark_url = BookmarkUrl.find_by_url(params[:user_bookmark][:bookmark_url_attributes][:url])
			#if bookmark_url doesn't exist submit new bookmark and bookmark url
			#else if it does exist add connection
			if @bookmark_url.nil?
				@user_bookmark = @playlist.user_bookmarks.build
				@user_bookmark.bookmark_name = params[:user_bookmark][:bookmark_name]
				@bookmark_url = BookmarkUrl.new(params[:user_bookmark][:bookmark_url_attributes])
				@user_bookmark.bookmark_url_id = @bookmark_url
				@bookmark_url.user_bookmarks << @user_bookmark
			else
				params[:user_bookmark].delete(:bookmark_url_attributes)
				@user_bookmark = @playlist.user_bookmarks.build(params[:user_bookmark])
				@user_bookmark.bookmark_url_id = @bookmark_url.id
				@bookmark_url.user_bookmarks << @user_bookmark
			end
			if(@bookmark_url.save and @user_bookmark.save and @playlist.save)
				redirect_to @playlist
			else
				render 'new'
			end
		else
			# give error message about it url being required
			@user_bookmark = @playlist.user_bookmarks.build
			@bookmark_url = BookmarkUrl.new 	#this is because i'm doing the 'new' form differently
			render 'new'
		end
	end

	def edit
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.find(params[:id])
		@bookmark_url = @user_bookmark.bookmark_url
	end

	def update
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.find(params[:id])
		@bookmark_url = BookmarkUrl.find_by_url(params[:user_bookmark][:bookmark_url_attributes][:url])
		@child_index = params[:user_bookmark][:bookmark_url_attributes].first.first.to_i
		if !(params[:user_bookmark][:bookmark_url_attributes][:url].nil?)
			#if it's the same url update the user_bookmark, else switch the url or create a new one
			@bookmark_url = BookmarkUrl.find_by_url(params[:user_bookmark][:bookmark_url_attributes][:url])
			if @bookmark_url.nil?
				@bookmark_url = BookmarkUrl.new(params[:user_bookmark][:bookmark_url_attributes]) #bookmark_url
				@bookmark_url.save
				@bookmark_url.user_bookmarks << @user_bookmark
				@user_bookmark.bookmark_url_id = @bookmark_url.id #user_bookmark side
			else
				if @bookmark_url.url !=  @user_bookmark.bookmark_url.url
					@user_bookmark.bookmark_url.user_bookmarks.delete @user_bookmark #detach old bookmark_url
					@bookmark_url.user_bookmarks << @user_bookmark #bookmark_url side
					@user_bookmark.bookmark_url_id = @bookmark_url.id #user_bookmark side
				end
			end
			params[:user_bookmark].delete(:bookmark_url_attributes)
			@user_bookmark.update_attributes(params[:user_bookmark])
			@user_bookmark.save
			@playlist.save
		else
			#create something about kind of error for when it's blank
		end
		respond_to do |format|
			format.html {redirect_to edit_playlist_path(@playlist)} #this should already handle errors
			format.js {render 'update.js.erb'} #this needs to handle errors
		end
	end 

	def destroy
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.find(params[:id])
		@user_bookmark.bookmark_url.user_bookmarks.delete @user_bookmark #detach old bookmark_url
		@playlist.user_bookmarks.delete @user_bookmark
		@user_bookmark.delete
		#save?
		respond_to do |format|
			format.html {redirect_to edit_playlist_path(@playlist)}
			# format.js {render 'delete'}
			format.js {render :nothing => true}
		end
	end

end
