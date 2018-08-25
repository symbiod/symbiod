# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::RemoveRole do
  subject { described_class }

  describe '#call' do
    let(:role) { 'member' }

    context 'user have two roles' do
      let(:user) { create(:user, :member, :staff) }

      it 'delete roles success' do
        expect { subject.call(user: user, role: role, size: user.roles.size) }
          .to change { user.reload.roles_name }
          .from(%w[member staff]).to(['staff'])
      end
    end

    context 'user have one role' do
      let(:user) { create(:user, :member) }

      it 'raise to delete last role' do
        expect { subject.call(user: user, role: role, size: user.roles.size) }
          .to raise_error(Ops::Member::UnassignRole::LastRoleError)
      end
    end
  end
end
