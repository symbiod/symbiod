# frozen_string_literal: true

module Web
  module Dashboard
    # Allows only staff to manage ideas
    class IdeaPolicy < DashboardPolicy
      def index?
        true
      end

      def show?
        true
      end

      def new?
        not_developer?
      end

      def create?
        not_developer?
      end

      def edit?
        not_developer?
      end

      def update?
        not_developer?
      end

      def activate?
        staff_or_mentor?
      end

      def deactivate?
        staff_or_mentor?
      end

      # Defines a scope of Ideas, who can be available for acting person
      class Scope < Scope
        def resolve
          if all_ideas?
            ::Idea.all
          elsif active_and_current_user_ideas?
            ::Idea.where('author_id = ? OR state = ?', user.id, 'active')
          elsif current_user_ideas?
            ::Idea.where(author_id: user.id)
          elsif active_ideas?
            ::Idea.actived
          end
        end

        private

        def all_ideas?
          user.has_role?(:staff) || user.has_role?(:mentor)
        end

        def active_and_current_user_ideas?
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
end
