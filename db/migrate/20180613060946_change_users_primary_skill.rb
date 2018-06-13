class ChangeUsersPrimarySkill < ActiveRecord::Migration[5.2]
  def up
    ruby = Skill.find_by(title: 'Ruby')
    User.all.each do |user|
      UserSkill.create(user: user, skill: ruby, primary: true)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
