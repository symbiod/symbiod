class CreateDeveloperTestTaskResults < ActiveRecord::Migration[5.1]
  def change
    create_table :developer_test_task_results do |t|
      t.string :link, null: false
      t.integer :developer_id, null: false
      t.integer :test_task_id, null: false

      t.timestamps
    end
    add_index :developer_test_task_results, :developer_id
  end
end
