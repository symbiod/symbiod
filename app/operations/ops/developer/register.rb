module Ops
  module Developer
    class Register < BaseOperation
      step :validate!
      step :persist!

      private

      def validate!(options, **)
        true
      end

      def persist!(options, **)
        User.create(options.to_hash.merge(role: 'developer'))
      end
    end
  end
end
