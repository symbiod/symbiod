class AddUnfinishedSurveyCounterToRoles < ActiveRecord::Migration[5.2]
  def up
    add_column :roles, :unfinished_survey_followup_counter, :integer
    change_column_default :roles, :unfinished_survey_followup_counter, 0
  end

  def down
    remove_column :roles, :unfinished_survey_followup_counter
  end
end
