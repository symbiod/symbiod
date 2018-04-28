module Web
  module Bootcamp
    class OauthsController < BaseController
      skip_before_action :require_login, raise: false

      def oauth
        login_at(provider)
      end

      def callback
        if (@user = login_from(provider))
          redirect_back_or_to(root_url(subdomain: 'www'), notice: t('landing.success_login', provider: provider.titleize))
        else
          @user = create_from(provider)
          reset_session
          auto_login(@user)
          redirect_back_or_to(root_url(subdomain: 'www'), notice: t('landing.success_login', provider: provider.titleize))
        end
      end

      private

      def auth_params
        params.permit(:code, :provider, :subdomain)
      end

      def provider
        auth_params[:provider]
      end
    end
  end
end
