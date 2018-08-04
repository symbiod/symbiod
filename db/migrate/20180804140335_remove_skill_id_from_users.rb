class RemoveSkillIdFromUsers < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :users, :skill_id }
  end
end
