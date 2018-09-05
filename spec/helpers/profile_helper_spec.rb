# frozen_string_literal: true

require 'rails_helper'

describe ProfileHelper do
  subject(:user) { create(:user) }
  subject(:with_assignment_completed) { create(:user, :with_assignment_completed) }

  describe 'human_date' do
    it { expect(human_date(user)).to eq user.created_at.strftime('%d-%m-%Y') }
  end

  describe 'github_link' do
    it {
      expect(github_link(user))
        .to eq "<a target=\"_blank\" href=\"https://github.com/#{user_github}\">#{user_github}</a>"
    }
  end

  describe 'test_task_link' do
    it {
      user_assigment = with_assignment_completed.test_task_assignments.first
      user_assigment_link = user_assigment.test_task_result.link
      expect(test_task_link(user_assigment))
        .to eq "<a target=\"_blank\" href=\"#{user_assigment_link}\">#{user_assigment_link}</a>"
    }
  end

  def user_github
    CGI.escapeHTML(user.github)
  end
end
