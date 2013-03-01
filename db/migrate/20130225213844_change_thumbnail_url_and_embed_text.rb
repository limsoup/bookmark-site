class ChangeThumbnailUrlAndEmbedText < ActiveRecord::Migration
  def change
		remove_column :bookmark_urls, :thumbnail_url
		add_column :bookmark_urls, :thumbnail_urls, :text
		add_column :bookmark_urls, :embed, :text
  end
end
