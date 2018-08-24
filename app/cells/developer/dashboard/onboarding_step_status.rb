# frozen_string_literal: true

module Developer
  module Dashboard
    # This cell renders status invite to slack or github
    class OnboardingStepStatus < BaseCell
      STATUS = {
        pending: 'danger',
        invited: 'warning',
        joined: 'success',
        left: 'danger',
        completed: 'success'
      }.freeze

      def onboarding_step_status
        content_tag :div, class: "btn btn-#{color_status} btn-sm disabled" do
          t("dashboard.users.table.#{invite_status}")
        end
      end

      private

      def invite_status
        return 'pending' unless model.developer_onboarding
        model.developer_onboarding[@options[:resource]].gsub(/\w*_/, '')
      end

      def color_status
        return 'danger' unless model.developer_onboarding
        STATUS[model.developer_onboarding[@options[:resource]].gsub(/\w*_/, '').to_sym]
      end
    end
  end
end
