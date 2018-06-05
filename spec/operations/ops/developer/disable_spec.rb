# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Disable do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user, :active) }
    let(:params) { { user: user } }

    it 'changes user state' do
      expect { subject.call(user: params[:user], params: params) }
        .to change(user.reload, :state)
        .from('active').to('disabled')
    end

    it 'sends notification to user' do
      expect { subject.call(user: params[:user], params: params) }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with('Developer::DisabledNotificationMailer', 'notify', 'deliver_now', user.id)
    end
  end
end
