class AddLastUnfinishedSurveyFollowupDateToRoles < ActiveRecord::Migration[5.2]
  def up
    add_column :roles, :last_unfinished_survey_followup_date, :datetime
    change_column_default :roles, :last_unfinished_survey_followup_date, -> {'CURRENT_TIMESTAMP'}
  end

  def down
    remove_column :roles, :last_unfinished_survey_followup_date
  end
end
