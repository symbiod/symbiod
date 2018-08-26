# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status invite to slack or github
    class OnboardingStepStatus < BaseCell
      def onboarding_step_status
        content_tag :div, class: "btn btn-#{color_status} btn-sm disabled" do
          t("dashboard.cells.button.#{invite_status}")
        end
      end

      private

      def invite_status
        # Here we accept the name of the model field in @options[:resourse]
        # and bring it to the form without the prefix, since we have the following
        # statuses: slack_pending, github_left, and so on.
        return 'pending' unless model.developer_onboarding
        resource_status
      end

      def color_status
        # Here we accept the name of the model field in @options[:resourse]
        # and bring it to the form without the prefix, since we have the following
        # statuses: slack_pending, github_left, and so on and take the value from
        # the hash for the button color
        return 'danger' unless model.developer_onboarding
        COLOR_STATUS[resource_status.to_sym]
      end

      def resource_status
        model.developer_onboarding[@options[:resource]].gsub(/\w*_/, '')
      end
    end
  end
end
