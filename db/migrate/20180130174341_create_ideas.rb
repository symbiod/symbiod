class CreateIdeas < ActiveRecord::Migration[5.1]
  def change
    create_table :ideas do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :author_id, null: false

      t.index [:author_id]
      t.timestamps
    end
  end
end
