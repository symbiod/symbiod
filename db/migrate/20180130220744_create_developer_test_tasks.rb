class CreateDeveloperTestTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :developer_test_tasks do |t|
      t.text :description, null: false

      t.timestamps
    end
  end
end
