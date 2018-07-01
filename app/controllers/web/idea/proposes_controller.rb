# frozen_string_literal: true

module Web
  module Idea
    # This controller allows you to create an idea from a public page
    class ProposesController < BaseController
      before_action :check_access

      rescue_from Pundit::NotAuthorizedError,
                  with: :redirect_to_idea_root

      def index
        @ideas = current_user.ideas
      end

      def new
        @idea = ::Idea.new
      end

      def create
        result = Ops::Idea::Submit.call(params: idea_params, author: current_user)
        if result.success?
          redirect_to idea_proposes_url
        else
          @idea = result[:model]
          render :new
        end
      end

      private

      def idea_params
        params.require(:idea).permit(:name, :description, :private, :skip_bootstrapping)
      end

      def check_access
        authorize %i[web idea propose], "#{action_name}?".to_sym
      end

      def redirect_to_idea_root
        flash[:danger] = t('idea.proposes.access.deny')
        redirect_to idea_root_url
      end
    end
  end
end
