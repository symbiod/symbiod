class AddColumnRoleIdToTestTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :developer_test_tasks, :role_id, :integer
  end
end
