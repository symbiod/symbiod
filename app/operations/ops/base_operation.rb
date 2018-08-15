# frozen_string_literal: true

module Ops
  # This is a based class
  class BaseOperation < Trailblazer::Operation
    private

    def slack_config
      Settings.slack
    end
  end
end
