# frozen_string_literal: true

module Web
  module Idea
    # Allows to sign in as author or staff by email/password
    class SessionsController < BaseController
      skip_before_action :verify_authenticity_token
      before_action :check_access

      rescue_from Pundit::NotAuthorizedError,
                  with: :redirect_to_idea_root

      def new
        @user = User.new
      end

      def create
        if (@user = login(resource_params[:email], resource_params[:password]))
          redirect_back_or_to idea_root_url, success: "#{t('landing.success_login')} #{@user.email}"
        else
          flash.now[:danger] = t('landing.failed_login')
          render action: 'new'
        end
      end

      private

      def resource_params
        params.require(:idea_login).permit(:email, :password)
      end

      def check_access
        authorize %i[web idea session], "#{action_name}?".to_sym
      end

      def redirect_to_idea_root
        flash[:danger] = t('idea.sessions.access.deny')
        redirect_to idea_root_url
      end
    end
  end
end
