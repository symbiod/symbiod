class AddTitleToTestTask < ActiveRecord::Migration[5.2]
  def change
    add_column :developer_test_tasks, :title, :string
  end
end
