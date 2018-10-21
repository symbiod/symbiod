class RemoveDefaultValueFromCounterRole < ActiveRecord::Migration[5.2]
  def up
    change_column_default :roles, :unfinished_survey_followup_counter, nil
  end
end
