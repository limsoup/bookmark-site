class AddRegularizeUsernameToUser < ActiveRecord::Migration
  def change
  	add_column :users, :regularized_username, :string
  	add_index :users, :regularized_username
  end
end
