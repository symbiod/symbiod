# frozen_string_literal: true

module Web
  module Dashboard
    # A base controller for all top-level dashboard controllers
    class BaseController < ApplicationController
      layout 'dashboard'

      include SubdomainUrlHelper

      before_action :require_login
      before_action :check_authentication
      rescue_from Pundit::NotAuthorizedError, with: :redirect_to_dashboard_root

      private

      def check_authentication
        return true if current_user.active? || current_user.has_role?(:stuff)
        redirect_to root_landing_url,
                    alert: t('landing.alerts.not_authenticated_dashboard_access')
      end

      def redirect_to_dashboard_root
        redirect_to dashboard_root_url
      end
    end
  end
end
