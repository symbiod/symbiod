# frozen_string_literal: true

module Developer
  module Dashboard
    # This cell rennder status test task
    class TestTaskStatusButton < BaseCell
      def test_task_status
        link_to model.state,
                change_state,
                method: :put,
                class: "btn btn-#{color_status} btn-sm",
                data: { confirm: t("dashboard.developer_test_task.link.confirm.#{confirm_status}") }
      end

      private

      def color_status
        model.active? ? 'success' : 'danger'
      end

      def confirm_status
        model.active? ? 'disable' : 'activate'
      end

      def change_state
        model.active? ? deactivate_dashboard_test_task_url(model) : activate_dashboard_test_task_url(model)
      end
    end
  end
end
