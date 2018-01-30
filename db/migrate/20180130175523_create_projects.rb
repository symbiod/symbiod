class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.integer :idea_id, null: false
      t.string :slug, null: false, uniqueness: true

      t.timestamps
    end
    add_index :projects, :idea_id
    add_index :projects, :slug
  end
end
