# frozen_string_literal: true

# Check the action for the slack service
class SlackPolicy < ApplicationPolicy
  def able_to_join_channel?(role)
    user.has_role? role
  end
end
