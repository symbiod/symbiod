# frozen_string_literal: true

module Users
  # Allows to find users, who should be notified about new applicant.
  # We should notify all staff members.
  # Additionally we notify mentors, who has the same specialization, as user.
  class ScreeningCompletedNotificationRecipientsQuery
    attr_reader :applicant

    def initialize(applicant)
      @applicant = applicant
    end

    def call
      staff + mentors_by_skill
    end

    private

    def staff
      User.with_any_role(:staff)
    end

    def mentors_by_skill
      # NOTICE: We do not use `with_any_role` Rolify scope, because it returns array instead of
      # AR relation ATM
      User.joins(:roles, :skills)
          .where('roles.type=?', 'Roles::Mentor')
          .where(user_skills: { skill_id: @applicant.primary_skill.id })
    end
  end
end
