# frozen_string_literal: true

module Member
  module Dashboard
    # This cell renders status user
    class BaseStatusButton < BaseCell
      private

      LINK_STATUS = {
        pending: ' disabled',
        profile_completed: ' disabled',
        rejected: ' disabled',
        policy_accepted: ' disabled',
        screening_completed: ' disabled'
      }.freeze

      COLOR_STATUS = {
        pending: 'danger',
        profile_completed: 'danger',
        rejected: 'danger',
        policy_accepted: 'danger',
        screening_completed: 'warning',
        active: 'success',
        disabled: 'danger',
        invited: 'warning',
        joined: 'success',
        left: 'danger',
        completed: 'success'
      }.freeze

      CONFIRM_STATUS = {
        active: 'disable',
        disabled: 'activate'
      }.freeze

      def link_to_status
        link_to model.state,
                url_status,
                method: :put,
                class: "btn btn-#{color_status} btn-sm#{link_status}",
                data: { confirm: t("dashboard.cells.links.confirm.#{confirm_status}") }
      end

      def link_status
        LINK_STATUS[model.state.to_sym]
      end

      def color_status
        COLOR_STATUS[model.state.to_sym]
      end

      def confirm_status
        CONFIRM_STATUS[model.state.to_sym]
      end
    end
  end
end
