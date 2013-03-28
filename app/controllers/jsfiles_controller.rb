require 'uri'
class JsfilesController < ApplicationController
	layout false
	def bookmarklet
		#logger.ap request.env
		@user_bookmark = UserBookmark.new
		respond_to do |format|
			format.js {
				render 'bookmarklet'}
			format.html {
				render 'bookmarklet_content'}
		end
	end

	def jquery_bookmarklet
		render 'jquery_bookmarklet.min'
	end

	def cleanslate
		render 'cleanslate'
	end

	def embed
		render 'embed'
	end

	def process_bookmarklet
		# logger.ap request.env['Bookmarklet-User-key']
		@user = User.find_by_bookmarklet_user_key(params['bookmarklet_user_key']);
		@user.reset_bookmarklet_user_key
		@user.save
		# add to default playlist if no playlist is selected
		if (params[:playlist_id].nil? or params[:playlist_id] == '')
			@user_bookmark = @user.default_list.user_bookmarks.build(:bookmark_name => params[:user_bookmark][:bookmark_name])
		else
			@user_bookmark = @user.playlists.find(params[:playlist_id]).user_bookmarks.build(:bookmark_name => params[:user_bookmark][:bookmark_name])
		end
		# @user_bookmark.bookmark_name = params[:user_bookmark][:bookmark_name]
		url = request.env["HTTP_REFERER"]	#something from request
		if URI.split(url)[5..8].join() == "/"
			url = params[:url]
		end
		@bookmark_url = BookmarkUrl.find_by_url(url)
		#if bookmark_url doesn't exist submit new bookmark and bookmark url
		#else if it does exist add connection
		@bookmark_url = BookmarkUrl.create(:url => url) if @bookmark_url.nil?
		@user_bookmark.bookmark_url_id = @bookmark_url.id
		@bookmark_url.user_bookmarks << @user_bookmark
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