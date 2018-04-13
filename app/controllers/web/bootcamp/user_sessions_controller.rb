module Web
  module Bootcamp
    class UserSessionsController < ApplicationController
      def new
        @form = ::Bootcamp::LoginForm.new(User.new)
      end

      def create
        result = Ops::Developer::Login.(resource_params)
        if result.success?
          redirect_to root_path, notice: 'Succesfully logged in'
        else
          render :new
        end
      end

      def destroy
        logout
        redirect_to root_path, notice: 'Succesfully logged out'
      end

      private

      def resource_params
        params.require(:bootcamp_login).permit(:email, :password)
      end
    end
  end
end
