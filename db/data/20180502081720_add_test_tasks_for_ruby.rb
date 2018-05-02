class AddTestTasksForRuby < ActiveRecord::Migration[5.2]
  def up
    task_1_description = 'You have the following legacy controller code: https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6
Suggest which parts of it can be improved and why. Please create a new gist, copy code there and comment it. Paste the link to gist as solution of this quiz.'
    Developer::TestTask.create!(description: task_1_description)

    task_2_description = 'Create a small Rails application, that implements the logic from gist https://gist.github.com/Mehonoshin/4c239ea364fe458ef844e3984b757cf6.
As a bonus you can make it 100% covered by tests and deployed to heroku.'
    Developer::TestTask.create!(description: task_2_description)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
