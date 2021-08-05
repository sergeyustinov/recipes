class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :string, index: true, null: false
  end
end
