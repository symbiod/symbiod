# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::AcceptPolicy do
  subject { described_class }
  let(:user) { create(:user, :pending) }

  describe '#call' do
    it 'changes users state if policy accepted' do
      expect { subject.call(user: user, params: { accept_policy: '1' }) }
        .to change { user.reload.state }
        .from('pending').to('policy_accepted')
    end

    it 'not changes users state if policy not accepted' do
      expect { subject.call(user: user, params: { accept_policy: '0' }) }
        .not_to(change { user.reload.state })
    end
  end
end
