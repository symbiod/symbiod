class RemoveRoleColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :role, :string, null: false
  end
end
