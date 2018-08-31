# frozen_string_literal: true

module Web
  module Bootcamp
    # Renders simple block with title and some text on the landing
    class LandingBlock < BaseCell
      def title
        I18n.t(model)[:title]
      end

      def body
        I18n.t(model)[:body]
      end
    end
  end
end
