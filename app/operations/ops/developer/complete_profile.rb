# frozen_string_literal: true

module Ops
  module Developer
    # Persists passed data and starts screening
    # bases on chosen technologies
    class CompleteProfile < ::Ops::Developer::BaseOperation
      NON_USER_PARAMS = %i[primary_skill_id role].freeze

      step ->(ctx, user:, **) { ctx[:model] = user }
      step Contract::Build(constant: ::Developer::Wizard::ProfileForm)
      step Contract::Validate()
      step Contract::Persist()
      success :assign_initial_role!
      success :assign_primary_skill!
      success :complete_profile!
      success :start_screening!

      private

      def assign_initial_role!(_ctx, user:, params:, **)
        user.add_role(params[:role])
      end

      def assign_primary_skill!(_ctx, user:, params:, **)
        skill = ::Skill.active.find(params[:primary_skill_id])
        UserSkill.create(user: user, skill: skill, primary: true)
      end

      def complete_profile!(_ctx, user:, **)
        role(user).complete_profile!
      end

      def start_screening!(_ctx, user:, **)
        Ops::Developer::Screening::Start.call(user: user)
      end
    end
  end
end
