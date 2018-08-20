require 'faker'
require 'yaml'

def create_user(number)
  User.create!(
    email: "test0#{number}@gmail.com",
    github: Faker::Name.last_name,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    location: Faker::Address.country,
    timezone: Faker::Address.time_zone,
    cv_url: Faker::Internet.url
  )
end

skills = YAML.load_file('data/skills.yml')

skills.each do |skill|
  Skill.create! title: skill
end

tasks = [
  { position: 1, role_name: 'developer', skill: Skill.find_by(title: 'Ruby'), title: 'Commente code', description: 'You have the following legacy controller code: https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6 Suggest which parts of it can be improved and why. Please create a new gist, copy code there and comment it. Paste the link to gist as solution of this quiz.' },
  { position: 2, role_name: 'developer', skill: Skill.find_by(title: 'Ruby'), title: 'Create application', description: 'Create a small Rails application, that implements the logic from gist https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6. As a bonus you can make it 100% covered by tests and deployed to heroku.' },
  { position: 1, role_name: 'mentor', skill: Skill.find_by(title: 'Ruby'), title: 'Mentor: Commente code', description: 'You have the following legacy controller code: https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6 Suggest which parts of it can be improved and why. Please create a new gist, copy code there and comment it. Paste the link to gist as solution of this quiz.' },
  { position: 2, role_name: 'mentor', skill: Skill.find_by(title: 'Ruby'), title: 'Mentor: Create application', description: 'Create a small Rails application, that implements the logic from gist https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6. As a bonus you can make it 100% covered by tests and deployed to heroku.' }
]

tasks.each do |task_attributes|
  Developer::TestTask.find_or_create_by!(task_attributes)
end

# Create members
55.times do |i|
  user = create_user(i)
  user.add_role Developer::Wizard::ProfileForm::ROLES.sample
  user.roles.last.update(state: %w[pending active disabled screening_completed].sample)
  UserSkill.create!(user: user, skill: Skill.all.sample, primary: true)
  Developer::Onboarding::SurveyResponse.create!(user_id: user.id, feedback: { test: 'ffff', test2: 'fff' })
end

stack = Stack.create!(name: 'Rails monolith', identifier: 'rails_monolith')
Skill.where(title: %w[Ruby Front-end]).each do |skill|
  stack.skills << skill
end
