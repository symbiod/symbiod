# frozen_string_literal: true

require 'rails_helper'

describe Developer::Dashboard::UserRoles do
  subject { described_class.new(developer, context: { controller: controller }) }
  let(:current_user) { create(:user, :active, :staff) }

  controller Web::Dashboard::UsersController

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  context 'current user staff and he can assign/unassign roles' do
    let(:developer) { create(:user, :developer) }

    it { expect(subject.link('developer')).to match(I18n.t('dashboard.users.unassign_role', role: 'developer')) }
    it { expect(subject.link('staff')).to match(I18n.t('dashboard.users.assign_role', role: 'staff')) }
    it { expect(subject.link('author')).to match(I18n.t('dashboard.users.assign_role', role: 'author')) }
    it { expect(subject.link('mentor')).to match(I18n.t('dashboard.users.assign_role', role: 'mentor')) }
  end
end
