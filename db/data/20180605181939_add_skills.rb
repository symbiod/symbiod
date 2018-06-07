require 'yaml'

class AddSkills < ActiveRecord::Migration[5.2]
  def up
    skills = YAML.load_file('data/skills.yml')
    skills.each do |skill|
      Skill.create! title: skill
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
