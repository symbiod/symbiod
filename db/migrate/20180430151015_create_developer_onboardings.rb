class CreateDeveloperOnboardings < ActiveRecord::Migration[5.2]
  def change
    create_table :developer_onboardings do |t|
      t.integer :user_id, null: false
      t.boolean :slack, default: false
      t.boolean :github, default: false

      t.timestamps
    end
  end
end
