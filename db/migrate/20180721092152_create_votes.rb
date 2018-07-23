class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.string :vote_type, null: false
      t.integer :idea_id
      t.integer :user_id

      t.timestamps
    end

    add_index :votes, :idea_id
    add_index :votes, :user_id
  end
end
