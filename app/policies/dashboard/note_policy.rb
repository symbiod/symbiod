# frozen_string_literal: true

module Dashboard
  # This class distributes rights to create notes
  class NotePolicy < DashboardPolicy
    def new?
      staff_or_mentor?
    end

    alias create? new?
  end
end
