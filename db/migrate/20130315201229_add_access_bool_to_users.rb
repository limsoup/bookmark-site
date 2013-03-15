class AddAccessBoolToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :access, :boolean, :default => true
  end
end
