# frozen_string_literal: true

# Allows only stuff to manage newcomers applications
class TestTaskAssignmentPolicy < ApplicationPolicy
  def index?
    stuff?
  end

  def show?
    stuff?
  end

  def activate?
    stuff?
  end

  def reject?
    stuff?
  end

  private

  def stuff?
    user.has_role? :stuff
  end
end
