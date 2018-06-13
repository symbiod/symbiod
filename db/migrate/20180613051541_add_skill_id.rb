class AddSkillId < ActiveRecord::Migration[5.2]
  def change
    add_column :developer_test_tasks, :skill_id, :integer
  end
end
