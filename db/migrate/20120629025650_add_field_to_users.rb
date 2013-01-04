class AddFieldToUsers < ActiveRecord::Migration
  def change
 add_column :users, :user_name,:text
  end
end
