# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Screening::SendScreeningFollowup do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user) }
    let!(:params) { { user: user } }

    it 'sends email to uncompleted users' do
      expect { subject.call(user: params[:user], params: params) }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with('Developer::Screening::SendFollowupMailer', 'notify', 'deliver_now', user.id)
    end

    it 'updates last followup date' do
      expect { subject.call(user: params[:user], params: params) }
        .to change { user.reload.last_screening_followup_date }
    end
  end
end
