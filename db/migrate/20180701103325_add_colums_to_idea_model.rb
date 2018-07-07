class AddColumsToIdeaModel < ActiveRecord::Migration[5.2]
  def up
    add_column :ideas, :private_project, :boolean
    change_column_default :ideas, :private_project, false
    add_column :ideas, :skip_bootstrapping, :boolean
    change_column_default :ideas, :skip_bootstrapping, false
    add_column :ideas, :state, :string, null: false
  end

  def down
    remove_column :ideas, :private_project
    remove_column :ideas, :skip_bootstrapping
    remove_column :ideas, :state
  end
end
