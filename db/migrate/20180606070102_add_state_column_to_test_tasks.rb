class AddStateColumnToTestTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :developer_test_tasks, :state, :string
  end
end
