class MigrateRoles < ActiveRecord::Migration[5.2]
  def up
    User.all.each do |user|
      user_roles = LegacyRolesQuery.call(user.id)
      user_roles.each do |role_name|
        user.add_role(role_name)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  class LegacyRolesQuery
    def self.call(user_id)
      ActiveRecord::Base
        .connection
        .execute("
                  SELECT role_id, lr.name
                  FROM users_roles ur
                  INNER JOIN legacy_roles lr
                  ON ur.role_id=lr.id
                  WHERE ur.user_id=#{user_id};")
        .to_a
        .map { |tuple| tuple['name'] }
    end
  end
end
