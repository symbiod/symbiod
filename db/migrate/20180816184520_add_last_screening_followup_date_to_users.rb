class AddLastScreeningFollowupDateToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_screening_followup_date, :datetime
  end
end
