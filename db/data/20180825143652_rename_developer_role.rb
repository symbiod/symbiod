class RenameDeveloperRole < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.connection.execute("UPDATE roles SET type='Roles::Mentor' WHERE type='Roles::Developer';")
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
