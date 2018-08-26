# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status user
    class BaseLinkStatusButton < BaseCell
      private

      def link_to_status(name: model.state, url: url_status, color: color_status, confirm: confirm_status)
        link_to t("dashboard.cells.button.#{name}"),
                url,
                method: :put,
                class: "btn btn-#{color} btn-sm#{link_status}",
                data: { confirm: t("dashboard.cells.links.confirm.#{confirm}") }
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
