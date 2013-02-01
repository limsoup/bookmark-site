class ChangeUserBookmarkNameDropDefaultName < ActiveRecord::Migration
  def change
  	rename_column :user_bookmarks, :name, :bookmark_name
  	remove_column :bookmark_urls, :default_name 
  end
end