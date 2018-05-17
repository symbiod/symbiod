# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Screening::Finish do
  describe '#call' do
    let(:user) { create(:user, :profile_completed) }

    context 'screening completed' do
      before { allow(user).to receive(:test_tasks_completed?).and_return(true) }

      it 'changes user state' do
        expect { described_class.call(user: user) }
          .to change { user.state }.to('screening_completed')
      end
    end

    context 'screening is not completed' do
      before { allow(user).to receive(:test_tasks_completed?).and_return(false) }

      it 'does not change user state' do
        expect { described_class.call(user: user) }
          .not_to change(user, :state)
      end
    end
  end
end
