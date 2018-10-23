class DropLastUnfinishedSurveyFollowupDate < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :roles, :last_unfinished_survey_followup_date }
  end
end
