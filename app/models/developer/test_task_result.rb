class Developer::TestTaskResult < ApplicationRecord
  validates :link, presence: true #todo: url format?

  belongs_to :developer, class_name: 'User'
  belongs_to :test_task, class_name: 'Developer::TestTask'
end
