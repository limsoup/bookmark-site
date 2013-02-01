class CreateBookmarkUrls < ActiveRecord::Migration
  def change
  	create_table :bookmark_urls do |t|
      t.string :default_name
      t.string :url
      t.timestamps
    end
  end
end
