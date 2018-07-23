class CreateStacks < ActiveRecord::Migration[5.2]
  def change
    create_table :stacks do |t|
      t.string :name, null: false
      t.string :identifier, null: false

      t.timestamps
    end

    add_index :stacks, :identifier
  end
end
