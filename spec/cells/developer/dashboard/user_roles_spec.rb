# frozen_string_literal: true

require 'rails_helper'

describe Developer::Dashboard::UserRoles do
  subject { described_class.new(developer, context: { controller: controller }) }

  controller Web::Dashboard::UsersController

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  context 'current user staff and he can assign/unassign roles' do
    let(:current_user) { create(:user, :active, :staff) }
    let(:developer) { create(:user, :developer) }

    it { expect(subject.render_role('developer')).to match(I18n.t('dashboard.users.unassign_role', role: 'developer')) }
    it { expect(subject.render_role('staff')).to match(I18n.t('dashboard.users.assign_role', role: 'staff')) }
    it { expect(subject.render_role('author')).to match(I18n.t('dashboard.users.assign_role', role: 'author')) }
    it { expect(subject.render_role('mentor')).to match(I18n.t('dashboard.users.assign_role', role: 'mentor')) }
    it { expect(subject.send(:list_roles).size).to eq 4 }
  end

  context 'current user mentor and he can not assign/unassign roles' do
    let(:current_user) { create(:user, :active, :mentor) }
    let(:developer) { create(:user, :developer) }

    it { expect(subject.render_role('developer')).to match('developer') }
    it { expect(subject.render_role('staff')).to match('staff') }
    it { expect(subject.render_role('author')).to match('author') }
    it { expect(subject.render_role('mentor')).to match('mentor') }
    it { expect(subject.send(:list_roles).size).to eq developer.roles.size }
  end
end
