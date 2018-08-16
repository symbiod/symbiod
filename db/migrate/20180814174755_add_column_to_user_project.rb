class AddColumnToUserProject < ActiveRecord::Migration[5.2]
  def up
    add_column :project_users, :mentor, :boolean
    change_column_default :project_users, :mentor, false
  end

  def down
    remove_column :project_users, :mentor
  end
end
