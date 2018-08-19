# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::SendScreeningFollowup do
  subject { described_class.call(user: user) }

  describe '#call' do
    let(:user) { create(:user, last_screening_followup_date: two_day_ago) }
    let(:old_date) { user.last_screening_followup_date }

    it 'sends email to uncompleted users' do
      expect { subject }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with('Developer::Screening::SendFollowupMailer', 'notify', 'deliver_now', user.id)
    end

    it 'updates last followup date' do
      binding.pry
      expect { subject }
        .to change { user.reload.last_screening_followup_date }
        .from(format_time(old_date)).to(format_time(Time.now))
    end
  end

  def format_time(time)
    time.strftime('%Y-%m-%d')
  end

  def two_day_ago
    Time.now - 60 * 60 * 24 * 2
  end
end
