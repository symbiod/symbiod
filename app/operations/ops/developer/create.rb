module Ops
  module Developer
    class Create < BaseOperation
      step :greet!

      def greet!(options, *)
        puts "Hello"
        true
      end
    end
  end
end
