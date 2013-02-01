class CreateUserBookmarks < ActiveRecord::Migration
  def change
  	create_table :user_bookmarks do |t|
      t.string :name
      t.integer :playlist_id
      t.integer :bookmark_url_id
      t.timestamps
    end
    add_index :user_bookmarks, :playlist_id
    add_index :user_bookmarks, :bookmark_url_id
  end
end
