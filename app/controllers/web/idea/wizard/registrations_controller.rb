# frozen_string_literal: true

module Web
  module Idea
    module Wizard
      # Allows user to register as an author
      class RegistrationsController < BaseController
        def new
          @registration = User.new
        end

        def create
          result = Ops::Author::SignUp.call(params: author_params)
          if result.success?
            login(author_params[:email], author_params[:password])
            redirect_to current_route_for_new_user
          else
            @registration = result[:model]
            render :new
          end
        end

        private

        def current_route_for_new_user
          public_send(Author::Wizard.new(result[:model]).route_for_current_step)
        end

        def author_params
          params.require(:user)
                .permit(:email, :first_name, :last_name, :location, :timezone, :password)
        end
      end
    end
  end
end
