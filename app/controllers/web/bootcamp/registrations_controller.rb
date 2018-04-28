module Web
  module Bootcamp
    class RegistrationsController < ApplicationController
      def new
        @form = ::Bootcamp::RegistrationForm.new(User.new)
      end

      def create
        result = Ops::Developer::Register.(resource_params)
        if result.success?
          login(params[:bootcamp_registration][:email], params[:bootcamp_registration][:password])
          redirect_to root_url(subdomain: 'www'), notice: t('landing.success_register')
        else
          render :new
        end
      end

      private

      def resource_params
        params.require(:bootcamp_registration).permit(:email, :name, :password)
      end
    end
  end
end
