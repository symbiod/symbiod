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
        result = Ops::Idea::Upvote.call(idea: @idea, user: current_user)
        if result['project']
          redirect_to dashboard_project_url(@idea.project),
                      flash: { success: t('dashboard.votes.notice.success_project') }
        else
          redirect_to dashboard_idea_url(@idea),
                      flash: { success: t('dashboard.votes.notice.success') }
        end
      end

      def down
        Ops::Idea::Downvote.call(idea: @idea, user: current_user)
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
