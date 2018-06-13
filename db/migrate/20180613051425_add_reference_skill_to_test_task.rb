class AddReferenceSkillToTestTask < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :users, :skill, index: false
    add_index :users, :skill_id, algorithm: :concurrently
  end
end
