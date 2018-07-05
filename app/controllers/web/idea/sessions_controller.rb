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

      # TODO: the method is repeated in the controllers, consider the possibility to render to an external module
      # https://github.com/howtohireme/give-me-poc/pull/288/files/ad43ef571eaee1aec2a04c576d1c66fa9a3f7817#diff-5481c70ecdd8763a256e81d531381b79
      def check_access
        authorize %i[ideas session], "#{action_name}?".to_sym
      end

      def redirect_to_idea_root
        flash[:danger] = t('idea.sessions.access.deny')
        redirect_to idea_root_url
      end
    end
  end
end
