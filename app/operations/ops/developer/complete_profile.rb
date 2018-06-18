# frozen_string_literal: true

module Ops
  module Developer
    # Persists passed data and starts screening
    # bases on chosen technologies
    class CompleteProfile < BaseOperation
      # TODO: use reform for validations here
      step :persist_profile_data!
      success :assign_initial_role!
      success :assign_primary_skill!
      success :complete_profile!
      success :start_screening!

      private

      def persist_profile_data!(_ctx, user:, params:, **)
        user.update(params)
      end

      def assign_initial_role!(_ctx, user:, params:, **)
        user.add_role(params[:role])
      end

      def assign_primary_skill!(_ctx, user:, params:, **)
        skill = ::Skill.find(params[:primary_skill_id])
        UserSkill.create(user: user, skill: skill, primary: true)
      end

      def complete_profile!(_ctx, user:, **)
        user.complete_profile!
      end

      def start_screening!(_ctx, user:, **)
        Ops::Developer::Screening::Start.call(user: user)
      end
    end
  end
end
