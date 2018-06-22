class ChangeColumnTestTaskAssotiationToRole < ActiveRecord::Migration[5.2]
  def up
    add_column :developer_test_tasks, :role_name, :string
    safety_assured { remove_column :developer_test_tasks, :role_id }
  end

  def down
    safety_assured { remove_column :developer_test_tasks, :role_name }
    add_column :developer_test_tasks, :role_id, :integer
  end
end
