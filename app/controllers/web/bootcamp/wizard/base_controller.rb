# frozen_string_literal: true

module Web
  module Bootcamp
    module Wizard
      class BaseController < ::Web::Bootcamp::BaseController
        before_action :require_login
        before_action :authorize_step!

        rescue_from Pundit::NotAuthorizedError do
          if wizard.active?
            redirect_to current_wizard_step_url
          else
            redirect_to bootcamp_root_url
          end
        end

        private

        def authorize_step!
          raise Pundit::NotAuthorizedError unless policy_class.new(current_user, nil).edit?
        end

        def policy_class
          raise 'Should be implemented in wizard step controller!'
        end
      end
    end
  end
end
