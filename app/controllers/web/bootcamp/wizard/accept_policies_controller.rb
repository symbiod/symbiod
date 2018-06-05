# frozen_string_literal: true

module Web
  module Bootcamp
    module Wizard
      # User must accept policy after registration and before filling profile
      class AcceptPoliciesController < BaseController
        def edit; end

        def update
          result = Ops::Developer::AcceptPolicy.call(
            user: current_user,
            params: profile_params
          )

          if result.success?
            redirect_to current_wizard_step_url
          else
            flash.now[:alert] = t('bootcamp.policy.must_be_accepted')
            render :edit
          end
        end

        private

        def profile_params
          params.require(:user).permit(:accept_policy)
        end

        def policy_class
          ::Bootcamp::Wizard::AcceptPolicyPolicy
        end
      end
    end
  end
end
