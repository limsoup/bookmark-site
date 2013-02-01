class UserBookmarksController < ApplicationController
	def new
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.build
		@bookmark_url = BookmarkUrl.new 	#this is because i'm doing the 'new' form differently
	end

	def create
		@playlist = current_user.playlists.find params[:playlist_id]
		#if bookmark_url doesn't exist submit new bookmark and bookmark url
		#else if it does exist add connection
		logger.ap params[:playlist]
		if !(params[:playlist][:user_bookmark][:bookmark_url].nil?)
			@bookmark_url = BookmarkUrl.find_by_url(params[:playlist][:user_bookmark][:bookmark_url][:url])
		end
		if @bookmark_url.nil?
			@user_bookmark = @playlist.user_bookmarks.build
			@user_bookmark.bookmark_name = params[:playlist][:user_bookmark][:bookmark_name]
			@bookmark_url = BookmarkUrl.new(params[:playlist][:user_bookmark][:bookmark_url])
			@user_bookmark.bookmark_url = @bookmark_url
			@bookmark.user_bookmarks << @user_bookmark
			if(@bookmark_url.save and @user_bookmark.save and @playlist.save)
				redirect_to @playlist
			else
				render 'new'
			end
		else
			params[:playlist][:user_bookmark].delete(:bookmark_url)
			@user_bookmark = @playlist.user_bookmarks.build
			@user_bookmark.bookmark_name = params[:playlist][:user_bookmark][:bookmark_name]
			@user_bookmark.bookmark_url = @bookmark_url
			@bookmark_url.user_bookmarks << @user_bookmark
			if(@bookmark_url.save and @user_bookmark.save and @playlist.save)
				redirect_to @playlist
			else
				render 'new'
			end
		end
	end

	def update
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.find(params[:id])
		@child_index = params[:playlist][:user_bookmarks_attributes].first.first.to_i
		if !(params[:playlist][:user_bookmark][:bookmark_url].nil?)
			#if it's the same url update the user_bookmark, else switch the url or create a new one
			@bookmark_url = BookmarkUrl.find_by_url(params[:playlist][:user_bookmark][:bookmark_url][:url])
			if @bookmark_url === @user_bookmark.bookmark_url.url
				params[:playlist][:user_bookmark].delete(:bookmark_url)
				@user_bookmark.bookmark_name = params[:playlist][:user_bookmark][:bookmark_name]
				
			else
				@bookmark_url = BookmarkUrl.new(params[:playlist][:user_bookmark][:bookmark_url])
				@bookmark_url.save
				@user_bookmark.bookmark_url = @bookmark_url
				@bookmark_url.user_bookmarks << @user_bookmark
			end
			@user_bookmark.save
			@playlist.save
			respond_to do |format|
				format.html {render 'playlist#edit'}			#this should already handle errors
				format.js {render 'update.js.erb'} #this needs to handle errors
			end
		else
			@user_bookmark.delete
			#save?
			respond_to do |format|
				format.html {render 'playlist#edit'}
				format.js {render 'delete'}
			end
		end
	end 

	def delete
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.find(params[:id])
		@user_bookmark.delete
		#save?
		respond_to do |format|
			format.html {render 'playlist#edit'}
			format.js {render 'delete'}
		end
	end


end
