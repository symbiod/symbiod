module Ops
  module Developer
    class Login < BaseOperation
      include Sorcery::Controller
      step :validate!
      step :login!

      private

      def validate!(options, **)
        Bootcamp::LoginForm.new(User.new).validate(user_params(options))
      end

      def login!(options, **)
        login(user_params(options)[:email], user_params(options)[:password])
      end

      def user_params(options)
        options.to_hash
      end
    end
  end
end
