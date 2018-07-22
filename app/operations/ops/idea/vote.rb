# frozen_string_literal: true

module Ops
  module Idea
    # This is the operation of creating a vote for the idea
    class Vote < BaseOperation
      step :create_vote!
    end
  end
end
