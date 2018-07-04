class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.text :content
      t.integer :noteable_id
      t.string  :noteable_type
      t.integer :commenter_id
      t.timestamps
    end

    add_index :notes, %i[noteable_type noteable_id]
    add_index :notes, :commenter_id
  end
end
