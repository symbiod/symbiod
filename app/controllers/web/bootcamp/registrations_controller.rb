module Web
  module Bootcamp
    class RegistrationsController < ApplicationController
      def new
        @form = ::Bootcamp::RegistrationForm.new(User.new)
      end

      def create
      end
    end
  end
end
