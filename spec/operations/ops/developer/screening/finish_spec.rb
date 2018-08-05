# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Screening::Finish do
  describe '#call' do
    let(:user) { create(:user, :developer, :policy_accepted) }
    let(:role) { role_for(user: user, role_name: :developer) }

    context 'screening completed' do
      before { allow(user).to receive(:test_tasks_completed?).and_return(true) }

      it 'changes role state' do
        expect { described_class.call(user: user) }
          .to change { role.reload.state }.to('screening_completed')
      end

      it 'sends notification about completed screening' do
        expect do
          described_class.call(user: user)
        end.to have_enqueued_job(ActionMailer::DeliveryJob)
          .with(
            'Staff::ScreeningCompletedMailer',
            'notify',
            'deliver_now',
            user.id
          )
      end
    end

    context 'screening is not completed' do
      before { allow(user).to receive(:test_tasks_completed?).and_return(false) }

      it 'does not change role state' do
        expect { described_class.call(user: user) }
          .not_to change(role, :state)
      end

      it 'does not send email' do
        expect do
          described_class.call(user: user)
        end.not_to have_enqueued_job(ActionMailer::DeliveryJob)
          .with(
            'Staff::ScreeningCompletedMailer',
            'notify',
            'deliver_now',
            user.id
          )
      end
    end
  end
end
