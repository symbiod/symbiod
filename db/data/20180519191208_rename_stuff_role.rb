class RenameStuffRole < ActiveRecord::Migration[5.2]
  def up
    Role.where(name: 'stuff').update_all(name: 'staff')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
