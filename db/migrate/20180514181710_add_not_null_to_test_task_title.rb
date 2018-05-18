class AddNotNullToTestTaskTitle < ActiveRecord::Migration[5.2]
  def change
    safety_assured { change_column :developer_test_tasks, :title, :string, null: false }
  end
end
