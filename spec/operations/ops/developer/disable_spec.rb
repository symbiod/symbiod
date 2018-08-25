# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::Disable do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user, :member, :active) }
    let(:params) { { user: user } }
    let(:role) { role_for(user: user, role_name: :member) }

    it 'changes role state' do
      expect { subject.call(user: params[:user], params: params) }
        .to change { role.reload.state }
        .from('active').to('disabled')
    end

    it 'sends notification to user' do
      expect { subject.call(user: params[:user], params: params) }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with('Member::DisabledNotificationMailer', 'notify', 'deliver_now', user.id)
    end
  end
end
