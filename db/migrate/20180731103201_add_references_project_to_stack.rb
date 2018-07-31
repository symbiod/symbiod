class AddReferencesProjectToStack < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :projects, :stack, foreign_key: true, index: false
    add_index :projects, :stack_id, algorithm: :concurrently
  end
end
