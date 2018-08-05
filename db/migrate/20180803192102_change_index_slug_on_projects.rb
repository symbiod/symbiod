class ChangeIndexSlugOnProjects < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    remove_index :projects, :slug
    add_index :projects, :slug, unique: true, algorithm: :concurrently
  end
end
