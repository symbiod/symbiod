# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::UncompletedUsers do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user) }
    let(:params) { { user: user } }

    it 'sends invitation to Github' do
      expect { subject.call(user: params[:user], params: params) }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with('Developer::SendFollowupMailer', 'notify', 'deliver_now', user.id)
    end
  end
end
