module Ops
  module Author
    class SignUp < BaseOperation
      step Model(User, :new)
      step Contract::Build(constant: ::Author::Registration)
      step Contract::Validate()
      step Contract::Persist()
      success :assign_role!

      private

      def assign_role!(_ctx, model:, **)
        model.add_role :author
      end
    end
  end
end
