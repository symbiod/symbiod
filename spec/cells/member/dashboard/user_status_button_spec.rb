# frozen_string_literal: true

require 'rails_helper'

describe Member::Dashboard::UserStatusButton do
  subject { described_class.new(candidate, context: { controller: controller }) }
  let(:current_user) { create(:user, :active, :staff) }

  controller Web::Dashboard::UsersController

  set_current_user

  shared_examples 'user staff and candidate not disabled' do
    it 'renders link to activate' do
      expect(subject.role_status).to match(/role_activation/)
    end

    it 'renders link to confirm status to activate' do
      expect(subject.role_status).to match(/data-confirm="Are you sure to activate/)
    end
  end

  shared_examples 'button state disabled' do
    it 'renders disabled button' do
      expect(subject.role_status).to match(/ disabled/)
    end
  end

  context 'current user staff and candidate status active' do
    let(:candidate) { create(:role, :member, :active) }

    it 'renders active status' do
      expect(subject.role_status).to match(/active/)
    end

    it 'renders success color link' do
      expect(subject.role_status).to match(/<a class="btn btn-success btn-sm"/)
    end

    it 'renders link to disable' do
      expect(subject.role_status).to match(/role_deactivation/)
    end

    it 'renders link to confirm status to disable' do
      expect(subject.role_status).to match(/data-confirm="Are you sure to disable/)
    end
  end

  context 'current user staff and candidate status not active' do
    let(:candidate) { create(:role, :member, :disabled) }

    it 'renders active status' do
      expect(subject.role_status).to match(/disabled/)
    end

    it 'renders danger color link' do
      expect(subject.role_status).to match(/<a class="btn btn-danger btn-sm"/)
    end

    it_behaves_like 'user staff and candidate not disabled'
  end

  context 'current user staff and candidate status pending' do
    let(:candidate) { create(:role, :member, :pending) }

    it 'renders active status' do
      expect(subject.role_status).to match(/pending/)
    end

    it 'renders warning color link' do
      expect(subject.role_status).to match(/<a class="btn btn-warning btn-sm disabled"/)
    end

    it_behaves_like 'user staff and candidate not disabled'
    it_behaves_like 'button state disabled'
  end

  context 'current user staff and candidate status profile completed' do
    let(:candidate) { create(:role, :member, :profile_completed) }

    it 'renders active status' do
      expect(subject.role_status).to match(/profile_completed/)
    end

    it 'renders danger color link' do
      expect(subject.role_status).to match(/<a class="btn btn-danger btn-sm disabled"/)
    end

    it_behaves_like 'user staff and candidate not disabled'
    it_behaves_like 'button state disabled'
  end

  context 'current user staff and candidate status screening completed' do
    let(:candidate) { create(:role, :member, :screening_completed) }

    it 'renders active status' do
      expect(subject.role_status).to match(/screening_completed/)
    end

    it 'renders danger color link' do
      expect(subject.role_status).to match(/<a class="btn btn-danger btn-sm disabled"/)
    end

    it_behaves_like 'user staff and candidate not disabled'
    it_behaves_like 'button state disabled'
  end

  context 'current user staff and candidate status rejected' do
    let(:candidate) { create(:role, :member, :rejected) }

    it 'renders active status' do
      expect(subject.role_status).to match(/rejected/)
    end

    it 'renders danger color link' do
      expect(subject.role_status).to match(/<a class="btn btn-danger btn-sm disabled"/)
    end

    it_behaves_like 'user staff and candidate not disabled'
    it_behaves_like 'button state disabled'
  end

  context 'current user status active and candidate status active' do
    let!(:current_user) { create(:user, :active) }
    let(:candidate) { create(:role, :member, :active) }

    it 'renders status active' do
      expect(subject.role_status).to match(/active/)
    end

    it 'does not renders link' do
      expect(subject.role_status).not_to match(/a class=/)
    end
  end
end
