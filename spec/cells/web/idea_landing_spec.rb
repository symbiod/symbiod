# frozen_string_literal: true

require 'rails_helper'

describe Web::IdeaLanding do
  subject { described_class.new(user, context: { controller: controller }) }

  controller Web::Idea::HomeController

  set_current_user

  context 'user with the role of the author and the status of pending for login' do
    let(:current_user) { create(:user, :author) }
    let(:user) { nil }

    it { expect(subject.render_link).to match('Go to proposal</a>') }
  end

  context 'user with the role of the author and the status of active for login' do
    let(:current_user) { create(:user, :author, :active) }
    let(:user) { nil }

    it { expect(subject.render_link).to match('Go to dashboard</a>') }
  end

  context 'user is not logged in' do
    let(:current_user) { nil }
    let(:user) { nil }

    it { expect(subject.render_link).to match('Offer an idea</a>') }
  end
end
