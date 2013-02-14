class ChangeCurrentBookmarkletOriginToBookmarkletUserKey < ActiveRecord::Migration
  def change
  	rename_column :users, :current_bookmarklet_origin, :bookmarklet_user_key
  	add_index :users, :bookmarklet_user_key
  end
end
