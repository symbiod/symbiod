class RemoveNameFromUsers < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :users, :name }
  end
end
