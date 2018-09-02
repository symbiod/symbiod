# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::AcceptPolicy do
  subject { described_class }
  let!(:user) { create(:user, :member, :profile_completed) }
  let!(:role) { role_for(user: user, role_name: :member) }

  describe '#call' do
    context 'accept policy' do
      it 'changes role state if policy accepted' do
        allow(Ops::Member::Screening::Start).to receive(:call).with(user: user)
        expect { subject.call(user: user, params: { accept_policy: '1' }) }
          .to change { role.reload.state }
          .from('profile_completed').to('policy_accepted')
      end

      it 'calls StartScreening operation' do
        expect(Ops::Member::Screening::Start)
          .to receive(:call)
          .with(user: user)
        subject.call(user: user, params: { accept_policy: '1' })
      end
    end

    context 'not accept policy' do
      it 'does not change role state if policy not accepted' do
        expect { subject.call(user: user, params: { accept_policy: '0' }) }
          .not_to(change { role.reload.state })
      end

      it 'StartScreening operation not calls' do
        expect(Ops::Member::Screening::Start)
          .not_to receive(:call)
          .with(user: user)
        subject.call(user: user, params: { accept_policy: '0' })
      end
    end
  end
end
