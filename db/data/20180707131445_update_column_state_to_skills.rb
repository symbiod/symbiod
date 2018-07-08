class UpdateColumnStateToSkills < ActiveRecord::Migration[5.2]
  def up
    Skill.all.update_all(state: 'active')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
