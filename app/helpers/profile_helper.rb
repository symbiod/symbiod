# frozen_string_literal: true

# Method to redering date registration of user
module ProfileHelper
  def human_date(user)
    user.created_at.strftime('%d-%m-%Y')
  end

  def github_link(user)
    link_to user.github, "https://github.com/#{user.github}", target: :_blank
  end

  def new_member_role_options
    Member::Wizard::ProfileForm::ROLES.map do |role|
      [t("specialists.profile.roles.#{role}"), role]
    end
  end
end
