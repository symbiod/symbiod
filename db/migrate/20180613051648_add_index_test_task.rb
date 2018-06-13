class AddIndexTestTask < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :developer_test_tasks, :skill_id, algorithm: :concurrently
  end
end
