# frozen_string_literal: true

module Web
  module Idea
    module Wizard
      # This controller allows you to create an idea from a public page
      class ProposalsController < BaseController
        def index
          @idea = ::Idea.new
        end

        def create
          result = Ops::Idea::Submit.call(params: idea_params, author: current_user)
          if result.success?
            redirect_to idea_wizard_proposals_url
          else
            @idea = result[:model]
            flash.now[:alert] = t('idea.wizard.proposals.fill_all_fields')
            render :index
          end
        end

        private

        def idea_params
          params.require(:idea).permit(:name, :description, :private_project, :skip_bootstrapping)
        end
      end
    end
  end
end
