class AddPrimarySkillToUsers < ActiveRecord::Migration[5.2]
  def up
    skill = Skill.find_by(title: 'Ruby')
    User.all.each do |user|
      UserSkill.create!(user: user, skill: skill, primary: true)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
