# frozen_string_literal: true

module Web
  module Idea
    module Wizard
      # Allows user to register as an author
      class RegistrationsController < BaseController
        before_action :check_access

        rescue_from Pundit::NotAuthorizedError,
                    with: :redirect_to_idea_root

        def new
          @registration = User.new
        end

        def create
          result = Ops::Author::SignUp.call(params: author_params)
          if result.success?
            login(author_params[:email], author_params[:password])
            redirect_to public_send(Author::Wizard.new(result[:model]).route_for_current_step)
          else
            @registration = result[:model]
            render :new
          end
        end

        private

        def author_params
          params.require(:user)
                .permit(:email, :first_name, :last_name, :location, :timezone, :password)
        end

        def check_access
          authorize %i[ideas registration], "#{action_name}?".to_sym
        end

        def redirect_to_idea_root
          flash[:danger] = t('idea.registrations.access.deny')
          redirect_to idea_root_url
        end
      end
    end
  end
end
