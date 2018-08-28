# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::RoleStatusButton do
  subject { described_class.new(role, context: { controller: controller }).link_to_status(confirm: role.state) }

  controller Web::Dashboard::RoleActivationController

  context 'role status active' do
    let(:role) { create(:role, :member, :active) }

    it_behaves_like 'button status is active'
  end

  context 'role status disabled' do
    let(:role) { create(:role, :member, :disabled) }

    it_behaves_like 'button status is disabled'
  end

  context 'role status pending' do
    let(:role) { create(:role, :member, :pending) }

    it_behaves_like 'button status is pending'
  end

  context 'role status profile completed' do
    let(:role) { create(:role, :member, :profile_completed) }

    it 'renders profile completed status' do
      expect(subject).to match(/profile completed/)
    end

    it_behaves_like 'danger and disabled'
  end

  context 'role status screening completed' do
    let(:role) { create(:role, :member, :screening_completed) }

    it 'renders screening completed status' do
      expect(subject).to match(/screening completed/)
    end

    it 'renders warning color' do
      expect(subject).to match(/<a class="btn btn-warning btn-sm/)
    end

    it 'renders disabled button' do
      expect(subject).to match(/ disabled/)
    end
  end

  context 'role status rejected' do
    let(:role) { create(:role, :member, :rejected) }

    it_behaves_like 'button status is rejected'
  end
end
