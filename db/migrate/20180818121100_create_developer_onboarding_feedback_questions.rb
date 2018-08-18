class CreateDeveloperOnboardingFeedbackQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :developer_onboarding_feedback_questions do |t|
      t.string :description, null: false
      t.string :key_name, null: false

      t.timestamps
    end

    add_index :developer_onboarding_feedback_questions, :key_name, unique: true
  end
end
