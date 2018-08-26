# frozen_string_literal: true

module Dashboard
  # Policy manage ideas, full access staff and mentor
  class IdeaPolicy < DashboardPolicy
    def index?
      true
    end

    def show?
      staff_or_author_record? || record.voting? && member?
    end

    def new?
      not_member?
    end

    alias create? new?

    def edit?
      staff_or_author_record?
    end

    alias update? edit?

    def voting?
      current_user_allow_voting?
    end

    def activate?
      current_user_allow_activate?
    end

    def deactivate?
      current_user_allow_deactivate?
    end

    def reject?
      current_user_allow_reject?
    end

    def manage?
      staff_or_mentor?
    end

    private

    def current_user_allow_voting?
      record.idea_pending? && staff_or_mentor?
    end

    def current_user_allow_activate?
      (record.disabled? || record.voting?) && staff_or_mentor?
    end

    def current_user_allow_deactivate?
      record.active? && staff_or_mentor?
    end

    def current_user_allow_reject?
      (record.idea_pending? || record.voting?) && staff_or_mentor? && current_user_not_author_idea
    end

    def current_user_not_author_idea
      record.author != user
    end

    # Defines a scope of Ideas, who can be available for acting person
    class Scope < Scope
      def resolve
        if all_ideas?
          ::Idea.all
        elsif voting_and_current_user_ideas?
          ::Idea.where('author_id = ? OR state = ?', user.id, 'voting')
        elsif current_user_ideas?
          ::Idea.where(author_id: user.id)
        elsif active_ideas?
          ::Idea.voting
        end
      end

      private

      def all_ideas?
        user.has_role?(:staff) || user.has_role?(:mentor)
      end

      def voting_and_current_user_ideas?
        user.has_role?(:member) && user.has_role?(:author)
      end

      def current_user_ideas?
        user.has_role? :author
      end

      def active_ideas?
        user.has_role? :member
      end
    end
  end
end
