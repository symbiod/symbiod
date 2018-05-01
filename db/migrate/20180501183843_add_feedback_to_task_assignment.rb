class AddFeedbackToTaskAssignment < ActiveRecord::Migration[5.2]
  def change
    add_column :developer_test_task_assignments, :feedback, :text
  end
end
