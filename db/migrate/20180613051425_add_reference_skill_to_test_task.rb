class AddReferenceSkillToTestTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :developer_test_tasks, :skill, foreign_key: true
  end
end
