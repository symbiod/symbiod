class MigrateApplicantsState < ActiveRecord::Migration[5.2]
  def up
    User.with_role_and_state(:developer, :profile_completed).each do |user|
      user.role(:developer).update(state: :policy_accepted)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
