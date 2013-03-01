class AddThumbnailUrlToBookmarkUrl < ActiveRecord::Migration
  def change
  	add_column :bookmark_urls, :thumbnail_url, :string
  end
end
