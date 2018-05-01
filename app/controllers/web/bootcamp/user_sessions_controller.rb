# frozen_string_literal: true

module Web
  module Bootcamp
    # ATM this controller used only for sign outs.
    # But this should be also a good place for email/password authentication.
    # TODO: Consider moving it to some root namespace,
    # so it can be used for other roles signup too
    class UserSessionsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def new
        @user = User.new
      end

      def create
        if (@user = login(resource_params[:email], resource_params[:password]))
          redirect_back_or_to(root_url(subdomain: 'www'), notice: t('landing.success_login', email: @user.email))
        else
          flash.now[:alert] = t('landing.failed_login')
          render action: 'new'
        end
      end

      def destroy
        logout
        reset_sorcery_session
        # NOTICE: For some reason Sorcery does not sign out properly
        # So we need to manualy nullify current user variable
        @current_user = nil
        redirect_back_or_to(root_url(subdomain: 'www'), notice: t('landing.logout'))
      end

      def resource_params
        params.require(:bootcamp_login).permit(:email, :password)
      end
    end
  end
end
