class AddLastScreeningFollowupDateToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :last_screening_followup_date, :datetime
    change_column_default :users, :last_screening_followup_date, -> { 'CURRENT_TIMESTAMP' }
  end

  def down
    remove_column :users, :last_screening_followup_date
  end
end
