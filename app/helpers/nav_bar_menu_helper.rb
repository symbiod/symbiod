# frozen_string_literal: true

# Providers methods for rendering nav bar menu on layout dashboard
module NavBarMenuHelper
  def nav_item_link(title, url, policy_name: :dashboard, icon: 'list')
    return unless Pundit.policy(current_user, policy_name).index?
    content_tag(:li, class: 'nav-item') do
      link_to(url, class: 'nav-link') do
        concat(content_tag(:span, nil, 'data-feather': icon))
        concat(title)
      end
    end
  end

  def count_applicants
    pending_applications = Role.where(state: :screening_completed).count
    "(#{pending_applications})" unless pending_applications.zero?
  end

  def count_pending_ideas
    pending_ideas = Idea.where(state: :pending).count
    "(#{pending_ideas})" unless pending_ideas.zero?
  end
end
