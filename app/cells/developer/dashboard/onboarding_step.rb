# frozen_string_literal: true

module Developer
  module Dashboard
    # This cell renders status invite to slack or github
    class OnboardingStep < BaseCell
      def status_onboarding_step
        content_tag :div, class: "btn btn-#{color_status} btn-sm" do
          t("dashboard.users.table.#{invite_status}")
        end
      end

      private

      def invite_status
        model.developer_onboarding.try(@options[:resource]) ? 'invited' : 'uninvited'
      end

      def color_status
        model.developer_onboarding.try(@options[:resource]) ? 'success' : 'danger'
      end
    end
  end
end
