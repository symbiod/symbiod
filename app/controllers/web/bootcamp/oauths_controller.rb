# frozen_string_literal: true

module Web
  module Bootcamp
    # Handles all sign in / sign up GitHub logic
    # On sign up it triggers Onboarding operation,
    # that runs all necessary steps for newcomer
    class OauthsController < BaseController
      skip_before_action :require_login, raise: false

      def oauth
        login_at(provider_name)
      end

      def callback
        sign_in || sign_up
      end

      private

      def sign_in
        @user = login_from(provider_name)
        return unless @user
        redirect_to bootcamp_root_url, notice: t('landing.success_login')
        @user
      end

      def sign_up
        if validate_github_profile
          start_screening
          redirect_to bootcamp_screenings_url, notice: t('landing.success_login')
        else
          redirect_to bootcamp_root_url, alert: t('bootcamp.landing.unfilled_github_email')
        end
      end

      def start_screening
        @user = create_from(provider_name)
        reset_session
        auto_login(@user)
        Ops::Developer::Screening::Start.call(user: @user)
      end

      def validate_github_profile
        provider_data['email'].present?
      end

      def auth_params
        params.permit(:code, :provider, :subdomain)
      end

      def provider_name
        auth_params[:provider]
      end

      def provider_data
        @user_hash[:user_info]
      end
    end
  end
end
