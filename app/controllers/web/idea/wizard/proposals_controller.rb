# frozen_string_literal: true

module Web
  module Idea
    module Wizard
      # This controller allows you to create an idea from a public page
      class ProposalsController < BaseController
        before_action :check_access

        rescue_from Pundit::NotAuthorizedError,
                    with: :redirect_to_idea_root

        def index
          @idea = ::Idea.new
        end

        def create
          result = Ops::Idea::Submit.call(params: idea_params, author: current_user)
          if result.success?
            redirect_to idea_wizard_proposals_url
          else
            @idea = result[:model]
            render :index
          end
        end

        private

        def idea_params
          params.require(:idea).permit(:name, :description, :private_project, :skip_bootstrapping)
        end

        def check_access
          authorize %i[ideas proposal], "#{action_name}?".to_sym
        end

        def redirect_to_idea_root
          flash[:danger] = t('idea.proposals.access.deny')
          redirect_to idea_root_url
        end
      end
    end
  end
end
