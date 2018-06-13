class AddReferenceSkillToTestTask < ActiveRecord::Migration[5.2]
  def change
    add_column :developer_test_tasks, :skill, :integer
  end
end
