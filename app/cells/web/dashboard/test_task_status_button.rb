# frozen_string_literal: true

module Web
  module Dashboard
    # This cell rennder status test task
    class TestTaskStatusButton < BaseLinkStatusButton
      private

      def url_status
        model.active? ? deactivate_dashboard_test_task_url(model) : activate_dashboard_test_task_url(model)
      end
    end
  end
end
