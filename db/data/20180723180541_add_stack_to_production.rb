class AddStackToProduction < ActiveRecord::Migration[5.2]
  def change
    stack = Stack.create!(name: 'Rails monolith', identifier: 'rails_monolith')
    Skill.where(title: %w[Ruby Front-end]).each do |skill|
      stack.skills << skill
    end
  end
end
