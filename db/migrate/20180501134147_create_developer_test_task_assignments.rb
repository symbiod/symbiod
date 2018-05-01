# frozen_string_literal: true

class CreateDeveloperTestTaskAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :developer_test_task_assignments do |t|
      t.integer :test_task_id
      t.integer :test_task_result_id
      t.integer :developer_id

      t.timestamps
    end
  end
end
