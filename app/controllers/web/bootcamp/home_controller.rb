module Web
  module Bootcamp
    class HomeController < BaseController
      def index
        render text: 'Bootcamp'
      end
    end
  end
end
