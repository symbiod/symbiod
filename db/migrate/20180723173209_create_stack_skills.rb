class CreateStackSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :stack_skills do |t|
      t.references :stack, foreign_key: true
      t.references :skill, foreign_key: true

      t.timestamps
    end
  end
end
