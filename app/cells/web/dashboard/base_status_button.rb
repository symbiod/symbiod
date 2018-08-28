# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status user
    class BaseStatusButton < BaseCell
      def link_to_status(status: model.state, url: url_status, confirm: nil)
        @status = status
        options = { method: :put }.merge(class_button).merge(tabindex).merge(data_confirm(confirm))
        link_to t("dashboard.cells.button.#{@status}"), url, options
      end

      private

      def link_status
        LINK_STATUS[@status.to_sym]
      end

      # Link functionality caveat
      # The .disabled class uses pointer-events: none to try to disable the link functionality of <a>s,
      # but that CSS property is not yet standardized. In addition, even in browsers that do support
      # pointer-events: none, keyboard navigation remains unaffected, meaning that sighted keyboard
      # users and users of assistive technologies will still be able to activate these links. So to be
      # safe, add a tabindex="-1" attribute on these links (to prevent them from receiving keyboard focus)
      # and use custom JavaScript to disable their functionality.
      def tabindex
        return {} unless LINK_STATUS[@status.to_sym]
        { tabindex: '-1' }
      end

      def class_button
        { class: "btn btn-#{COLOR_STATUS[@status.to_sym]} btn-sm #{link_status}".rstrip }
      end

      def data_confirm(confirm)
        return {} unless confirm
        { data: { confirm: t("dashboard.cells.links.confirm.#{CONFIRM_STATUS[confirm.to_sym]}") } }
      end

      def url_status
        raise 'Implement in child class'
      end
    end
  end
end
