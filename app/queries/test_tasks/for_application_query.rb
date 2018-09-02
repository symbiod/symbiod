# frozen_string_literal: true

module TestTasks
  # This query looks for active test tasks by the name of the role, primary skill and position
  class ForApplicationQuery
    attr_reader :positions, :user

    def initialize(positions, user)
      @positions = positions
      @user = user
    end

    def call
      # TODO: potentially unsafe picking just first role
      # we need probably to pass which role do we want to assign.
      # ATM not sure how to figure out that.
      (1..@positions).inject([]) do |test_tasks, position|
        test_tasks << ::Member::TestTask.active.where(
          position: position,
          role_name: user.roles_name.first,
          skill_id: user.primary_skill.id
        ).sample
      end.compact.flatten
    end
  end
end
