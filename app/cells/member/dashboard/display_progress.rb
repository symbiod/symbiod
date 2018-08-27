# frozen_string_literal: true

module Member
  module Dashboard
    # This cell renders progress bar user
    class DisplayProgress < BaseCell
      def progress_bar
        content_tag :div, class: "progress-bar bg-#{status_bar}", style: "width: #{width_bar}%" do
          "#{model.progress} %"
        end
      end

      private

      def status_bar
        model.progress.zero? ? 'danger' : 'success'
      end

      def width_bar
        model.progress.zero? ? 100 : model.progress
      end
    end
  end
end
