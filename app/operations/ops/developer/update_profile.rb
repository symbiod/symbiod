# frozen_string_literal: true

module Ops
  module Developer
    # This class to update user primary skill and params when editing user
    class UpdateProfile < BaseOperation
      step ->(ctx, user:, **) { ctx[:model] = user }
      step Contract::Build(constant: ::Developer::UpdateUserForm)
      step Contract::Validate()
      step Contract::Persist()
      success :update_primary_skill!

      private

      def update_primary_skill!(_ctx, user:, params:, **)
        skill = ::Skill.active.find(params[:primary_skill_id])
        user.user_skills.first.update(skill: skill)
      end
    end
  end
end
