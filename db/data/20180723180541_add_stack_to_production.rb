class AddStackToProduction < ActiveRecord::Migration[5.2]
  def change
    stack = Stack.create!(name: 'Rails monolith', identifier: 'rails_monolith')
    Skill.where(title: %w[Ruby JavaScript]).each do |skill|
      StackSkill.create!(stack: stack, skill: skill)
    end
  end
end
