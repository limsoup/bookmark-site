class BookmarkUrlsController < ApplicationController
	def create
		if params[:playlist_id].nil? # from some location that isn't specific to a particular playlist
			@playlist = current_user.default_list
		else
			@playlist = current_user.lists.find(params[:bookmark_url][:playlist_id]).first
		end
		@user_bookmark = @playlist.user_bookmarks.build
		if (@bookmark_url = BookmarkUrl.find_by_url params[:bookmark_url][:url] ).nil?
			@bookmark_url = BookmarkUrl.create(:url => params[:bookmark_url][:url])
		end
		render '/user_bookmarks/new'
	end
end