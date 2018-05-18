# frozen_string_literal: true

module Web
  module Bootcamp
    module Wizard
      # Allows user to fill his profile during the sign up process
      class ProfilesController < BaseController
        def edit
          @profile = current_user
          render :edit
        end

        def update
          result = Ops::Developer::CompleteProfile.call(
            user: current_user,
            params: profile_params
          )

          if result.success?
            redirect_to current_wizard_step_url
          else
            render :edit
          end
        end

        private

        def profile_params
          params
            .require(:user)
            .permit(:first_name, :last_name, :location, :timezone, :cv_url)
        end

        def policy_class
          ::Bootcamp::Wizard::ProfilePolicy
        end
      end
    end
  end
end
