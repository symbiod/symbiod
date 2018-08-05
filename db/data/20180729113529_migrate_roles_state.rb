class MigrateRolesState < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.transaction do
      User.all.each do |user|
        RoleMigrator.new(user).call
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  class RoleMigrator
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      migrate_developer_role
      migrate_other_roles
    end

    private

    def migrate_developer_role
      return unless user.has_role?(:developer)
      developer_role = Roles::RolesManager.new(user).role_for(:developer)
      developer_role.update(state: user.state)
    end

    def migrate_other_roles
      [:mentor, :author, :staff].each do |role_name|
        next unless user.has_role?(role_name)
        role_object = Roles::RolesManager.new(user).role_for(role_name)
        role_object.update(state: 'active')
      end
    end
  end
end
