class SkillToRuby < ActiveRecord::Migration[5.2]
  def up
    ruby = Skill.find_by(title: 'Ruby')
    Developer::TestTask.all.each do |task|
      task.update(skill_id: ruby.id)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
