class JsfilesController < ApplicationController
	layout false
	def bookmarklet
		@user_bookmark = UserBookmark.new
		respond_to do |format|
			format.js {logger.ap "Requesting JS"
				render 'bookmarklet'}
			format.html {logger.ap "Requesting HTML"
				render 'bookmarklet_content'}
		end
	end

	def process_bookmarklet
		# logger.ap request.env['Bookmarklet-User-key']
		@current_user = User.find_by_bookmarklet_user_key(params['bookmarklet_user_key']);
		@current_user.reset_bookmarklet_user_key
		@current_user.save
		# add to default playlist if no playlist is selected
		if(params[:playlist_id] == "")
			@user_bookmark = @current_user.default_list.user_bookmarks.build(:bookmark_name => params[:user_bookmark][:bookmark_name])
		else
			@user_bookmark = @current_user.lists.find(params[:playlist_id]).user_bookmarks.build(:bookmark_name => params[:user_bookmark][:bookmark_name])
		end
		# @user_bookmark.bookmark_name = params[:user_bookmark][:bookmark_name]
		url = request.env["HTTP_REFERER"]	#something from request
		@bookmark_url = BookmarkUrl.find_by_url(url)
		#if bookmark_url doesn't exist submit new bookmark and bookmark url
		#else if it does exist add connection
		if @bookmark_url.nil?
			@bookmark_url = BookmarkUrl.new(:url => url)
			@user_bookmark.bookmark_url_id = @bookmark_url.id
			@bookmark_url.user_bookmarks << @user_bookmark
		else
			@user_bookmark.bookmark_url_id = @bookmark_url.id
			@bookmark_url.user_bookmarks << @user_bookmark
		end
		@bookmark_url.save
		@user_bookmark.save
		respond_to do |format|
			format.json { render :json => {"successful"=> true} }
			format.html { 
				logger.ap "html bookmarklet request"
				render :json => {"successful"=> true} 
			}
		end
	end

	def preflight
		respond_to do |format|
			format.json { render :json => {"pre-preflight successful"=> true} }
			format.html { 
				logger.ap "html pre pre flight request"
				render :json => {"pre-preflight successful"=> true}
			}
		end
	end
end