# frozen_string_literal: true

module Web
  module Idea
    module Wizard
      # Requires to accept policy by author
      class PoliciesController < ::Web::Idea::Wizard::BaseController
        def edit; end

        def update
          result = Ops::Author::AcceptPolicy
                   .call(author: current_role, params: params[:user])

          if result.success?
            redirect_to current_wizard_step_url
          else
            flash.now[:alert] = t('idea.wizard.policy.must_be_accepted')
            render :edit
          end
        end
      end
    end
  end
end
