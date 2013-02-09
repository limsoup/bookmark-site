class UserBookmarksController < ApplicationController
	def new
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.build
		@bookmark_url = BookmarkUrl.new 	#this is because i'm doing the 'new' form differently
	end

	def create
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
				@bookmark_url.user_bookmarks<< @user_bookmark
			else
				params[:user_bookmark].delete(:bookmark_url_attributes)
				@user_bookmark = @playlist.user_bookmarks.build(params[:user_bookmark])
				@user_bookmark.bookmark_url_id = @bookmark_url.id
				@bookmark_url.user_bookmarks << @user_bookmark
			end
			if(@bookmark_url.save and @user_bookmark.save and @playlist.save)
				if(current_user.default_list == @playlist)
					redirect_to current_user
				else
					redirect_to @playlist
				end
			else
				render 'new'
			end
		else
			# give error message about the url being required
			@user_bookmark = @playlist.user_bookmarks.build
			@bookmark_url = BookmarkUrl.new 	#this is because i'm doing the 'new' form differently
			render 'new'
		end
	end

	def edit
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.find(params[:id])
		@bookmark_url = @user_bookmark.bookmark_url
		respond_to do |format|
			format.html {
				if request.xhr?
					render :partial =>'bookmark_fields', :layout => false, :locals => {:user_bookmark => @user_bookmark}  
				else
					render 'edit'
				end
			 }
		end
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
				@bookmark_url = BookmarkUrl.new(params[:user_bookmark][:bookmark_url_attributes]) #
				@bookmark_url.user_bookmarks << @user_bookmark
				@bookmark_url.save 	#need to save so UB can store the BU.id
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
			# give error message about the url being required
		end
		respond_to do |format|
			format.html {
				if request.xhr?
					render :partial =>'bookmark_fields', :layout => false, :locals => {:user_bookmark => @user_bookmark} 
				else
					redirect_to edit_playlist_path(@playlist) #need to make this show errors
				end
			}
			# format.js {render :partial => 'update.js.erb'} #this needs to handle errors
			# format.js {j render :partial =>'bookmark_fields', :layout => false, :locals => {:user_bookmark => @user_bookmark} } #this needs to handle errors
		end
	end

	def move
		# logger.ap request.env
		@source_playlist = current_user.playlists.find(params[:playlist_id])
		@dest_playlist = Playlist.find(params[:destination])
		@user_bookmark = @source_playlist.user_bookmarks.find(params[:id])
		@bookmark_url = @user_bookmark.bookmark_url
		@new_bookmark = @dest_playlist.user_bookmarks.build(:bookmark_name => @user_bookmark.bookmark_name)
		@dest_playlist.user_bookmarks<<@new_bookmark
		@bookmark_url.user_bookmarks<<@new_bookmark
		@dest_playlist.save
		@bookmark_url.save
		if(params[:moveType]=='cut')
			@user_bookmark.delete
		end
		respond_to do |format|
			format.html { redirect_to user_path(current_user) }
			format.json { 
				# if(params[:moveType]=='cut')
				resp = {"delete" => (params[:moveType]=='cut')}
				render :json => resp
				# else
				# 	render :nothing => true
				# end
			}
		end			
	end

	def destroy
		@playlist = current_user.playlists.find params[:playlist_id]
		@user_bookmark = @playlist.user_bookmarks.find(params[:id])
		@user_bookmark.bookmark_url.user_bookmarks.delete @user_bookmark #detach old bookmark_url
		@playlist.user_bookmarks.delete @user_bookmark
		@user_bookmark.delete 	#is this necessary?(I think so if i don't make ) is it even okay?
		#save?
		respond_to do |format|
			format.html {redirect_to edit_playlist_path(@playlist)}
			# format.js {render 'delete'}
			format.js {render :nothing => true}
		end
	end

end
