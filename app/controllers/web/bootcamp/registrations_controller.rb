module Web
  module Bootcamp
    class RegistrationsController < ApplicationController
      def new
        @form = ::Bootcamp::RegistrationForm.new(User.new)
      end

      def create
        result = Ops::Developer::Register.(resource_params)
        if result.success?
          redirect_to root_path, notice: 'Application submitted'
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
