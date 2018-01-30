class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :role, null: false
      t.string :name
      t.string :github

      t.timestamps
    end
  end
end
