class CreateRolesTable < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    create_table :roles do |t|
      t.string :type
      t.integer :user_id
    end

    add_index :roles, :type, algorithm: :concurrently
    add_index :roles, :user_id, algorithm: :concurrently
    add_index :roles, [:type, :user_id], algorithm: :concurrently
  end
end
