# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Onboarding::SubmitSurveyResponse do
  subject { described_class }
  let(:user) { create(:user, :developer, :active) }

  describe '#call' do
    context 'valid params' do
      let(:params) do
        {
          user_id: user.id,
          question_1: 'Answer 1',
          question_2: 'Answer 2'
        }
      end

      it 'create survey response' do
        expect { subject.call(params: params) }
          .to change(::Developer::Onboarding::SurveyResponse, :count).by(1)
      end

      it 'send email notification' do
        expect { subject.call(params: params) }
          .to have_enqueued_job(ActionMailer::DeliveryJob)
          .with('Staff::SurveyResponseCompletedMailer', 'notify', 'deliver_now', user.id)
      end
    end

    context 'invalid params' do
      let(:params) do
        {
          user_id: user.id,
          question_1: 'Answer 1',
          question_2: ''
        }
      end

      it 'create survey response' do
        expect { subject.call(params: params) }
          .to change(::Developer::Onboarding::SurveyResponse, :count).by(0)
      end

      it 'not send email notification' do
        expect { subject.call(params: params) }
          .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(0)
      end
    end
  end
end
