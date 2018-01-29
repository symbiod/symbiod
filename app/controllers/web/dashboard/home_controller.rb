module Web
  module Dashboard
    class HomeController < BaseController
      def index
        render text: 'Dashboard'
      end
    end
  end
end
