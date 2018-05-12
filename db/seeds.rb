tasks = [
  { description: 'You have the following legacy controller code: https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6 Suggest which parts of it can be improved and why. Please create a new gist, copy code there and comment it. Paste the link to gist as solution of this quiz.' },
  { description: 'Create a small Rails application, that implements the logic from gist https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6. As a bonus you can make it 100% covered by tests and deployed to heroku.' }
]

tasks.each do |task_attributes|
  Developer::TestTask.find_or_create_by!(task_attributes)
end

9.times do |i|
  User.create!(email: "test0#{i}@gmail.com", name: "test0#{i}", state: %w[active disabled screening_completed].sample)
end
