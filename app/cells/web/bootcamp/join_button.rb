# frozen_string_literal: true

module Web
  module Bootcamp
    # Render the button, located at home bootcamp page.
    # It can behave in different manner, depending on current member role state.
    class JoinButton < BaseCell
      def current_user
        model.user
      end

      def wizard
        model
      end

      def wizard_step
        options[:current_wizard_step_url]
      end
    end
  end
end
