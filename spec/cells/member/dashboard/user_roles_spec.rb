# frozen_string_literal: true

require 'rails_helper'

describe Member::Dashboard::UserRoles do
  subject { described_class.new(member, context: { controller: controller }) }

  controller Web::Dashboard::UsersController

  set_current_user

  context 'current user staff and he can assign/unassign roles' do
    let(:current_user) { create(:user, :active, :staff) }
    let(:member) { create(:user, :member) }

    it { expect(subject.render_role('member')).to be_kind_of Member::Dashboard::UserStatusButton }
    it { expect(subject.render_role('staff')).to match(I18n.t('dashboard.users.assign_role', role: 'staff')) }
    it { expect(subject.render_role('author')).to match(I18n.t('dashboard.users.assign_role', role: 'author')) }
    it { expect(subject.render_role('mentor')).to match(I18n.t('dashboard.users.assign_role', role: 'mentor')) }
    it { expect(subject.send(:list_roles).size).to eq 4 }
  end

  context 'current user mentor and he can not assign/unassign roles' do
    let(:current_user) { create(:user, :active, :mentor) }
    let(:member) { create(:user, :member) }

    it { expect(subject.render_role('member')).to match('member') }
    it { expect(subject.render_role('staff')).to match('staff') }
    it { expect(subject.render_role('author')).to match('author') }
    it { expect(subject.render_role('mentor')).to match('mentor') }
    it { expect(subject.send(:list_roles).size).to eq member.roles.size }
  end
end
