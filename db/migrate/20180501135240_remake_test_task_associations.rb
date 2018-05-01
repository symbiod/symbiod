# frozen_string_literal: true

class RemakeTestTaskAssociations < ActiveRecord::Migration[5.2]
  def change
    remove_column :developer_test_task_results, :developer_id
    remove_column :developer_test_task_results, :test_task_id
  end
end
