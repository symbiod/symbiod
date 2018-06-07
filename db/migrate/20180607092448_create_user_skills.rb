class CreateUserSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :user_skills do |t|
      t.boolean :primary, default: false
      t.references :skill, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
