class AddCurrentBookmarkletOriginToUser < ActiveRecord::Migration
  def change
  	add_column :users, :current_bookmarklet_origin, :string
  end
end