require 'rails_helper'

describe Ops::Author::AcceptPolicy do
  subject { described_class.call(arguments) }
  let(:author) { create(:role, :author, :pending) }

  describe '.call' do
    context 'when policy accepted' do
      let(:arguments) { { author: author, params: { accept_policy: '1' } } }

      it 'changes role state' do
        expect { subject }
          .to change { author.reload.state }
          .from('pending')
          .to('policy_accepted')
      end
    end

    context 'when policy is not accepted' do
      let(:arguments) { { author: author, params: {} } }

      it 'changes role state' do
        expect { subject }
          .not_to change { author.reload.state }
          .from('pending')
      end
    end
  end
end
