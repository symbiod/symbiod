class AddStateColumnToSkills < ActiveRecord::Migration[5.2]
  def change
    add_column :skills, :state, :string
  end
end
