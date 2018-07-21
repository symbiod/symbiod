# frozen_string_literal: true

module Web
  module Dashboard
    # Manage votes to ideas
    class VotesController < BaseController
      before_action :idea_find, only: %i[index up down]
      rescue_from Pundit::NotAuthorizedError, with: :redirect_to_dashboard_idea

      def index
        @votes = @idea.votes
      end

      def up
        Ops::Idea::Vote.call(idea: @idea, user: current_user, vote_type: 'up')
        redirect_to dashboard_idea_url(@idea),
                    flash: { success: t('dashboard.votes.notice.success') }
      end

      def down
        Ops::Idea::Vote.call(idea: @idea, user: current_user, vote_type: 'down')
        redirect_to dashboard_idea_url(@idea),
                    flash: { success: t('dashboard.votes.notice.success') }
      end

      private

      def idea_find
        @idea ||= ::Idea.find(params[:idea_id])
        authorize @idea, policy_class: ::Dashboard::VotePolicy
      end

      def redirect_to_dashboard_idea
        redirect_to dashboard_idea_url(@idea),
                    flash: { warning: t('dashboard.votes.notice.warning') }
      end
    end
  end
end
