class RenameDeveloperTables < ActiveRecord::Migration[5.2]
  def change
    safety_assured do
      rename_table :developer_onboarding_feedback_questions, :member_onboarding_feedback_questions
      rename_table :developer_onboarding_survey_responses, :member_onboarding_survey_responses
      rename_table :developer_onboardings, :member_onboardings
      rename_table :developer_test_task_assignments, :member_test_task_assignments
      rename_table :developer_test_task_results, :member_test_task_results
      rename_table :developer_test_tasks, :member_test_tasks
      rename_column :member_test_task_assignments, :developer_id, :member_id
    end
  end
end
