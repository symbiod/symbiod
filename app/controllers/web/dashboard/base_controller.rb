# frozen_string_literal: true

module Web
  module Dashboard
    # A base controller for all top-level dashboard controllers
    class BaseController < ApplicationController
      layout 'dashboard'

      include SubdomainUrlHelper

      before_action :require_login
      before_action :check_authorization
      rescue_from Pundit::NotAuthorizedError do |exception|
        exception.query == :allowed? ? redirect_to_root_landing : redirect_to_dashboard_root
      end

      private

      def check_authorization
        return true if authorize(:dashboard, :allowed?)
      end

      def redirect_to_root_landing
        flash[:danger] = t('landing.alerts.not_authenticated_dashboard_access')
        redirect_to root_landing_url
      end

      def redirect_to_dashboard_root
        flash[:danger] = t('dashboard.users.access.deny')
        redirect_to dashboard_root_url
      end
    end
  end
end
