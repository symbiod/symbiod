class AddColumnmentorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :mentor, :boolean
    add_column :developer_test_tasks, :role_id, :integer
  end
end
