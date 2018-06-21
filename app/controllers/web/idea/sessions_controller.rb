# frozen_string_literal: true

module Web
  module Idea
    # Allows to sign in as author or staff by email/password
    class SessionsController < BaseController
      skip_before_action :verify_authenticity_token

      def new
        @user = User.new
      end

      def create
        if (@user = login(resource_params[:email], resource_params[:password]))
          redirect_back_or_to(root_landing_url, notice: t('landing.success_login', email: @user.email))
        else
          flash.now[:alert] = t('landing.failed_login')
          render action: 'new'
        end
      end

      private

      def resource_params
        params.require(:idea_login).permit(:email, :password)
      end
    end
  end
end
