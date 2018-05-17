# frozen_string_literal: true

module Web
  module Bootcamp
    module Wizard
      class BaseController < ::Web::Bootcamp::BaseController
        before_action :require_login
      end
    end
  end
end
