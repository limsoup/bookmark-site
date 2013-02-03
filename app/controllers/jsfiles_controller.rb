class JsfilesController < ApplicationController
	layout false
	def bookmarklet
		@user_bookmark = UserBookmark.new
		respond_to do |format|
			format.js {logger.ap "Requesting JS"
				render 'bookmarklet.js.erb'}
			format.html {logger.ap "Requesting HTML"
				render 'bookmarklet_content.html.erb'}
		end
	end

	def process_bookmarklet
		logger.ap params
		logger.ap request.env
		respond_to do |format|
			format.js { render :nothing => true }	
		end
	end
end