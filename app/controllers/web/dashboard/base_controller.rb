# frozen_string_literal: true

module Web
  module Dashboard
    # A base controller for all top-level dashboard controllers
    class BaseController < ApplicationController
      layout 'dashboard'

      include SubdomainUrlHelper

      before_action :require_login
      before_action :check_authorization
      rescue_from Pundit::NotAuthorizedError, with: :redirect_to_dashboard_root

      private

      def check_authorization
        return true if authorize(:dashboard, :allowed?)
        redirect_to root_landing_url,
                    alert: t('landing.alerts.not_authenticated_dashboard_access')
      end

      def redirect_to_dashboard_root
        flash[:danger] = t('dashboard.users.access.deny')
        redirect_to dashboard_root_url
      end
    end
  end
end
