class SetProjectUsersColumnMentorToFalse < ActiveRecord::Migration[5.2]
  def up
    ProjectUser.all.update_all(mentor: false)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
