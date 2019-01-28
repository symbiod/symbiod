# frozen_string_literal: true

module Ops
  module Idea
    # This operation create idea
    class Submit < BaseOperation
      step Model(::Idea, :new)
      step :assign_current_user!
      step Contract::Build(constant: ::Propose::ProposeForm)
      step Contract::Validate()
      step Contract::Persist()
      unless Rails.env.development?
        success :send_message_to_slack!
      end

      private

      def assign_current_user!(_ctx, params:, author:, **)
        params[:author_id] = author.id
      end

      # TODO: Most probably we need first to post the message to some channel
      # where staff only is present.
      def send_message_to_slack!(_ctx, model:, **)
        ::Ideas::MessageToSlackJob.perform_later(model.id)
      end
    end
  end
end
