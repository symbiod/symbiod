# frozen_string_literal: true

module Web
  module Idea
    module Wizard
      # Base class for all wizard steps
      # Provides ability to redirect to the next step automatically
      # if currect page does not match current step
      class BaseController < ::Web::Idea::BaseController
        before_action :redirect_to_current_step

        private

        def redirect_to_current_step
          redirect_to current_wizard_step_url unless authorized_step?
        end

        def authorized_step?
          policy_class.new(current_user, nil).authorized?
        end

        def policy_class
          resource_name = params[:controller].split('/').last.singularize.capitalize
          "::Ideas::Wizard::#{resource_name}Policy".constantize
        end

        helper_method def current_wizard_step_url
          public_send(wizard.route_for_current_step)
        end

        helper_method def wizard
          Author::Wizard.new(current_user)
        end

        def current_role
          Roles::RolesManager.new(current_user).role_for(:author)
        end
      end
    end
  end
end
