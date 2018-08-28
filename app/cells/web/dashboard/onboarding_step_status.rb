# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status invite to slack or github
    class OnboardingStepStatus < BaseStatusButton
      def onboarding_step_status
        link_to_status status: resource_status,
                       url: ''
      end

      private

      def resource_status
        # Here we accept the name of the model field in @options[:resourse]
        # and bring it to the form without the prefix, since we have the following
        # statuses: slack_pending, github_left, and so on.
        return 'pending' unless model.member_onboarding
        model.member_onboarding[@options[:resource]].gsub(/\w*_/, '')
      end
    end
  end
end
