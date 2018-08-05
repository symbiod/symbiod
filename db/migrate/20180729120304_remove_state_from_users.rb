class RemoveStateFromUsers < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :users, :state }
  end
end
