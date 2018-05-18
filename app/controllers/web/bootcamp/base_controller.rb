# frozen_string_literal: true

module Web
  module Bootcamp
    # Base class for all bootcamp controllers
    class BaseController < ApplicationController
      private

      helper_method def current_wizard_step_url
        public_send(wizard.route_for_current_step)
      end

      helper_method def wizard
        Developer::Wizard.new(current_user)
      end
    end
  end
end
