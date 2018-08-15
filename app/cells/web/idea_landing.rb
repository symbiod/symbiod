# frozen_string_literal: true

module Web
  # This cell displays links depending on the status of the current user
  class IdeaLanding < BaseCell
    def render_link
      title, link_path = params_link
      link_to t("idea.landing.#{title}"), link_path, class: 'btn btn-lg btn-secondary'
    end

    private

    def params_link
      if current_user.present?
        author_status
      else
        ['author_log_in', new_idea_wizard_registrations_url]
      end
    end

    def author_status
      if DashboardPolicy.new(current_user, nil).allowed?
        ['go_to_dashboard', dashboard_root_url]
      else
        ['go_to_proposal', public_send(Author::Wizard.new(current_user).route_for_current_step)]
      end
    end
  end
end
