# frozen_string_literal: true

require 'rails_helper'

describe ProfileHelper do
  subject(:user) { create(:user) }

  describe 'human_date' do
    it { expect(human_date(user)).to eq user.created_at.strftime('%d-%m-%Y') }
  end

  describe 'github_link' do
    it {
      expect(github_link(user))
        .to eq "<a target=\"_blank\" href=\"https://github.com/#{user_github}\">#{user_github}</a>"
    }
  end

  def user_github
    CGI.escapeHTML(user.github)
  end
end
