# frozen_string_literal: true

# Method to redering date registration of user
module ProfileHelper
  def human_date(user)
    user.created_at.strftime('%d-%m-%Y')
  end

  def github_link(user)
    link_to user.github, "https://github.com/#{user.github}", target: :_blank
  end

  def test_task_link(assignment)
    link_to assignment.test_task_result.link, "#{assignment.test_task_result.link}", target: :_blank
  end
end
