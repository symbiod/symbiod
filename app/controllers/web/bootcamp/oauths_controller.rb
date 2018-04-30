module Web
  module Bootcamp
    class OauthsController < BaseController
      skip_before_action :require_login, raise: false

      def oauth
        login_at(provider)
      end

      def callback
        sign_in || sign_up
        redirect_back_or_to(root_url(subdomain: 'www'), notice: t('landing.success_login', provider: provider.titleize))
      end

      private

      def sign_in
        @user = login_from(provider)
      end

      def sign_up
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        Ops::Developer::Onboarding.call(user: @user)
      end

      def auth_params
        params.permit(:code, :provider, :subdomain)
      end

      def provider
        auth_params[:provider]
      end
    end
  end
end
