# frozen_string_literal: true

module Web
  module Dashboard
    # A base controller for all top-level dashboard controllers
    class BaseController < ApplicationController
      layout 'dashboard'

      include SubdomainUrlHelper

      before_action :check_authentication

      private

      def check_authentication
        return true if current_user
        redirect_to root_landing_url,
                    alert: t('landing.alerts.not_authenticated_dashboard_access')
      end
    end
  end
end
