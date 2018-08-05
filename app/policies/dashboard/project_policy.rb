# frozen_string_literal: true

module Dashboard
  # Policy manage ideas, full access staff and mentor
  class ProjectPolicy < DashboardPolicy
    def index?
      true
    end

    def show?
      staff_or_author_record? || record.users.include?(user)
    end

    def edit?
      staff_or_author_record?
    end

    alias update? edit?

    # Defines a scope of Projects, who can be available for acting person
    class Scope < Scope
      def resolve
        if staff_or_mentor?
          Project.all
        elsif developer?
          user.projects
        elsif author?
          Projects::ProjectsAuthorIdeaQuery.new(user).call
        end
      end

      private

      def staff_or_mentor?
        user.has_role?(:staff) || user.has_role?(:mentor)
      end

      def developer?
        user.has_role?(:developer)
      end

      def author?
        user.has_role? :author
      end
    end
  end
end
