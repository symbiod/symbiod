# frozen_string_literal: true

module Web
  module Bootcamp
    # Handles all redirection and restictions logic for bootcamp area
    class BaseController < ApplicationController
      #before_action :check_if_wizard_completed?, if: :current_user

      private

      # Force user to visit screening, if it is not completed yet
      # Othervise redirect him to dashboard
      def check_if_wizard_completed?
        if wizard.completed?
          redirect_to dashboard_root_url
        elsif current_wizard_step_url != request.original_url
          redirect_to current_wizard_step_url
        end
      end

      def user_active?
        current_user.active?
      end

      def current_wizard_step_url
        public_send(wizard.route_for_current_step)
      end

      def wizard
        Developer::Wizard.new(current_user)
      end
    end
  end
end
