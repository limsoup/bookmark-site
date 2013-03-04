class AddUserProvedHumanBoolToUser < ActiveRecord::Migration
  def change
  	add_column :users, :human, :boolean
  end
end
