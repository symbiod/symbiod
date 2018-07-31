class CreateProjectUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :project_users do |t|
      t.references :project, foreign_key: true
      t.references :user, foreign_key: true
      t.index %i[project_id user_id], unique: true

      t.timestamps
    end
  end
end
