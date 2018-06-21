# frozen_string_literal: true

module Web
  module Bootcamp
    module Wizard
      # Allows user to fill his profile during the sign up process
      class ProfilesController < BaseController
        def edit
          @profile = ::Developer::Wizard::ProfileForm.new(current_user)
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
            @profile = result['result.contract.default']
            render :edit
          end
        end

        private

        def profile_params
          params
            .require(:developer_wizard_profile)
            .permit(:first_name, :last_name, :location,
                    :timezone, :cv_url, :role, :primary_skill_id)
        end

        def policy_class
          ::Bootcamp::Wizard::ProfilePolicy
        end
      end
    end
  end
end
