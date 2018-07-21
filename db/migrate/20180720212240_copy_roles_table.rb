class CopyRolesTable < ActiveRecord::Migration[5.2]
  def change
    safety_assured { rename_table :roles, :legacy_roles }
  end
end
