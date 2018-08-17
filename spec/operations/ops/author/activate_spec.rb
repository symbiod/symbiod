# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ops::Author::Activate do
  subject { described_class.call(author: author) }
  let(:author) { create(:role, :author, :policy_accepted) }

  describe 'call' do
    it 'changes role state' do
      expect { subject }
        .to change { author.reload.state }
        .from('policy_accepted')
        .to('active')
    end

    it 'sends notification' do
      expect { subject }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with(
          'Author::RoleActivatedMailer',
          'notify',
          'deliver_now',
          author.id
        )
    end
  end
end
