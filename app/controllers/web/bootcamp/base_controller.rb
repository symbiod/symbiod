# frozen_string_literal: true

module Web
  module Bootcamp
    # Handles all redirection and restictions logic for bootcamp area
    class BaseController < ApplicationController
      before_action :check_if_screening_completed?, if: :current_user

      private

      # Force user to visit screening, if it is not completed yet
      # Othervise redirect him to dashboard
      def check_if_screening_completed?
        if user_active?
          redirect_to dashboard_root_url
        elsif controller_name != 'screenings'
          redirect_to bootcamp_screenings_url
        end
      end

      def user_active?
        current_user.active?
      end
    end
  end
end
