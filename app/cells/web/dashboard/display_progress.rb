# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders progress bar user
    class DisplayProgress < BaseCell
      def progress_bar
        content_tag :div,
                    "#{model.progress} %",
                    class: "progress-bar bg-#{status_bar}",
                    style: "width: #{width_bar}%"
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
