# frozen_string_literal: true

module Ops
  module Author
    # With this action the author becomes an active user of the system.
    # He will be able to visit dashboard and view the progress of his idea.
    class Activate < BaseOperation
      step :change_state!
      step :send_notification!

      private

      def change_state!(_ctx, author:, **)
        author.activate!
        true
      end

      def send_notification!(_ctx, author:, **)
        ::Author::RoleActivatedMailer.notify(author.id).deliver_later
      end
    end
  end
end
