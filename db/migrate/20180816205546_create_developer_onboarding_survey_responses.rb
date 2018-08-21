class CreateDeveloperOnboardingSurveyResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :developer_onboarding_survey_responses do |t|
      t.jsonb :feedback, null: false
      t.references :role, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
