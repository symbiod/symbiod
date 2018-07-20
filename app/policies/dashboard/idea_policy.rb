# frozen_string_literal: true

module Dashboard
  # Policy manage ideas, full access staff and mentor
  class IdeaPolicy < DashboardPolicy
    def index?
      true
    end

    alias show? index?

    def new?
      not_developer?
    end

    alias create? new?
    alias edit? new?
    alias update? new?

    def activate?
      staff_or_mentor?
    end

    alias deactivate? activate?
    alias reject? activate?

    # Defines a scope of Ideas, who can be available for acting person
    class Scope < Scope
      def resolve
        if all_ideas?
          ::Idea.all
        elsif activated_and_current_user_ideas?
          ::Idea.where('author_id = ? OR state = ?', user.id, 'active')
        elsif current_user_ideas?
          ::Idea.where(author_id: user.id)
        elsif active_ideas?
          ::Idea.active
        end
      end

      private

      def all_ideas?
        user.has_role?(:staff) || user.has_role?(:mentor)
      end

      def activated_and_current_user_ideas?
        user.has_role?(:developer) && user.has_role?(:author)
      end

      def current_user_ideas?
        user.has_role? :author
      end

      def active_ideas?
        user.has_role? :developer
      end
    end
  end
end
