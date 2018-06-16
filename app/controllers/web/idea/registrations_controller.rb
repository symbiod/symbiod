# frozen_string_literal: true

module Web
  module Idea
    # Allows user to register as an author
    class RegistrationsController < BaseController
      def new
        @registration = User.new
      end

      def create
        result = Ops::Author::SignUp.call(params: author_params)
        if result.success?
          redirect_to dashboard_root_url
        else
          @registration = result[:model]
          puts "ERRORS: #{@registration.errors.inspect}"
          render :new
        end
      end

      private

      def author_params
        params.require(:user)
          .permit(:email, :first_name, :last_name, :location, :timezone, :password)
      end
    end
  end
end
