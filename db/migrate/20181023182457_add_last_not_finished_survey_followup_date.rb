class AddLastNotFinishedSurveyFollowupDate < ActiveRecord::Migration[5.2]
  def up
    add_column :roles, :last_not_finished_survey_followup_date_at, :datetime
    change_column_default :roles, :last_not_finished_survey_followup_date_at, -> { 'CURRENT_TIMESTAMP' }
  end

  def down
    remove_column :roles, :last_not_finished_survey_followup_date_at
  end
end
