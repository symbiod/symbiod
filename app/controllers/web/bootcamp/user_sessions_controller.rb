module Web
  module Bootcamp
    class UserSessionsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def new
        @user = User.new
      end

      def create
        if @user = login(params[:bootcamp_login][:email], params[:bootcamp_login][:password])
          redirect_back_or_to(root_url(subdomain: 'www'), notice: t('landing.success_login', email: @user.email))
        else
          flash.now[:alert] = t('landing.failed_login')
          render action: 'new'
        end
      end

      def destroy
        logout
        redirect_back_or_to(root_url(subdomain: 'www'), notice: t('landing.logout'))
      end

      def resource_params
        params.require(:bootcamp_login).permit(:email, :password)
      end
    end
  end
end
