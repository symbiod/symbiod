# frozen_string_literal: true

require 'rails_helper'

describe ProfileHelper do
  subject(:user) { create(:user) }
  subject(:with_assignment_completed) { create(:user, :with_assignment_completed) }

  describe '.human_date' do
    specify { expect(human_date(user)).to eq user.created_at.strftime('%d-%m-%Y') }
  end

  describe '.github_link' do
    specify do
      expect(github_link(user))
        .to eq "<a target=\"_blank\" href=\"https://github.com/#{user_github}\">#{user_github}</a>"
    end
  end

  describe '.new_member_role_options' do
    specify do
      expect(new_member_role_options)
        .to eq [[t('bootcamp.profile.roles.member'), 'member'], [t('bootcamp.profile.roles.mentor'), 'mentor']]
    end
  end

  def user_github
    CGI.escapeHTML(user.github)
  end
end
