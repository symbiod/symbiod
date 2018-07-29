# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::AcceptPolicy do
  subject { described_class }
  let(:user) { create(:user, :developer, :profile_completed) }
  let(:role) { role_for(user: user, role_name: :developer) }

  describe '#call' do
    it 'changes role state if policy accepted' do
      expect { subject.call(user: user, params: { accept_policy: '1' }) }
        .to change { role.reload.state }
        .from('profile_completed').to('policy_accepted')
    end

    it 'does not change role state if policy not accepted' do
      expect { subject.call(user: user, params: { accept_policy: '0' }) }
        .not_to(change { role.reload.state })
    end
  end
end
