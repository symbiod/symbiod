# frozen_string_literal: true

module Ops
  module Author
    # Validates params for author role
    # and creates user with appropriate role
    class SignUp < BaseOperation
      step Model(User, :new)
      step Contract::Build(constant: ::Author::RegistrationForm)
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
