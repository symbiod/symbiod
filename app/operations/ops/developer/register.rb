module Ops
  module Developer
    class Register < BaseOperation
      step :greet!

      def greet!(options, *)
        puts "Hello"
        true
      end
    end
  end
end
