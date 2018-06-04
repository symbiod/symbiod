require 'faker'
require 'yaml'

tasks = [
  { position: 1, title: 'Commente code', description: 'You have the following legacy controller code: https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6 Suggest which parts of it can be improved and why. Please create a new gist, copy code there and comment it. Paste the link to gist as solution of this quiz.' },
  { position: 2, title: 'Create application', description: 'Create a small Rails application, that implements the logic from gist https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6. As a bonus you can make it 100% covered by tests and deployed to heroku.' }
]

skills = YAML.load_file('data/skills.yml')

tasks.each do |task_attributes|
  Developer::TestTask.find_or_create_by!(task_attributes)
end

9.times do |i|
  user = User.create!(
    email: "test0#{i}@gmail.com",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    location: Faker::Address.country,
    timezone: Faker::Address.time_zone,
    cv_url: Faker::Internet.url,
    role: User::ROLES.sample,
    state: %w[pending active disabled screening_completed].sample
  )
  user.add_role User::ROLES.sample
end

skills.each do |skill|
  Skill.create! title: skill
end
