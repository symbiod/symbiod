module Web
  module Idea
    class HomeController < BaseController
      def index
        render text: 'Idea'
      end
    end
  end
end
