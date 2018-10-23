class AddDefaultValueToUnfinishedSurveyCounterFollowupCounter < ActiveRecord::Migration[5.2]
  def change
    change_column_default :roles, :unfinished_survey_followup_counter, 0
  end
end
