# frozen_string_literal: true

module TestTasks
  # This query looks for active test tasks by the name of the role, primary skill and position
  class ByPositionRoleAndSkillQuery
    attr_reader :position, :user

    def initialize(position, user)
      @position = position
      @user = user
    end

    def call
      ::Member::TestTask.active.where(
        position: position,
        role_name: user.roles_name.first,
        skill_id: user.primary_skill.id
      )
    end
  end
end
