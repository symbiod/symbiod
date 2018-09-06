# frozen_string_literal: true

module Dashboards
  # This cell returns the ending dashboard ready for rendering
  class Repository < BaseCell
    REPOSITORY = {
      member: 'Dashboards::Member',
      author: 'Dashboards::Author',
      mentor: 'Dashboards::Mentor',
      staff: 'Dashboards::Staff'
    }.freeze

    private

    def member_options
      { projects: Project.includes(:stack).all }
    end

    def mentor_options
      { mentor_options: '' }
    end

    def author_options
      { author_options: '' }
    end

    def staff_options
      { staff_options: '' }
    end
  end
end
