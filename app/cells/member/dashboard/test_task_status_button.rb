# frozen_string_literal: true

module Member
  module Dashboard
    # This cell rennder status test task
<<<<<<< HEAD:app/cells/member/dashboard/test_task_status_button.rb
    class TestTaskStatusButton < BaseCell
      def test_task_status
        link_to model.state,
                change_state,
                method: :put,
                class: "btn btn-#{color_status} btn-sm",
                data: { confirm: t("dashboard.member_test_task.link.confirm.#{confirm_status}") }
      end

=======
    class TestTaskStatusButton < BaseStatusButton
>>>>>>> (#316) refactoring activation/deactivation buttons:app/cells/developer/dashboard/test_task_status_button.rb
      private

      def url_status
        model.active? ? deactivate_dashboard_test_task_url(model) : activate_dashboard_test_task_url(model)
      end
    end
  end
end
