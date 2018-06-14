# frozen_string_literal: true

module Ops
  module Developer
    # This class to update user primary skill and params when editing user
    class UpdateProfile < BaseOperation
      step :persist_profile_data!
      success :update_primary_skill!

      private

      def persist_profile_data!(_ctx, user:, params:, **)
        user.update(params)
      end

      def update_primary_skill!(_ctx, user:, params:, **)
        skill = ::Skill.find(params[:primary_skill_id])
        user.user_skills.first.update(skill: skill)
      end
    end
  end
end
