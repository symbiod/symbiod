# frozen_string_literal: true

module Dashboard
  # This class distributes rights to create notes
  class NotePolicy < DashboardPolicy
    def new?
      staff_or_mentor?
    end

    alias create? new?

    def edit?
      staff_or_mentor? && record.commenter == user
    end

    alias update? edit?
    alias destroy? new?
  end
end
