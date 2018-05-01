class DisableNullAtTestTaskAssignment < ActiveRecord::Migration[5.2]
  def change
    change_column :developer_test_task_assignments, :test_task_id, :integer, null: false
    change_column :developer_test_task_assignments, :developer_id, :integer, null: false
  end
end
