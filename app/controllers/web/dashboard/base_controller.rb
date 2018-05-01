module Web
  module Dashboard
    class BaseController < ApplicationController
      layout 'dashboard'

      include SubdomainUrlHelper

      before_action :check_authentication

      private

      def check_authentication
        redirect_to root_landing_url,
          alert: t('landing.alerts.not_authenticated_dashboard_access') unless current_user
      end
    end
  end
end
