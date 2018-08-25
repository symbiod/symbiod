# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Onboarding::CreateSurveyResponse do
  subject { described_class }
  before do
    create(:feedback_question, key_name: 'question_1')
    create(:developer_onboarding, user: user)
  end

  describe '#call' do
    let!(:user) { create(:user, :developer, :active) }

    context 'valid params' do
      let(:params) do
        {
          question_1: 'answer',
          role_id: user.role(:developer).id
        }
      end

      it 'feedback was created' do
        expect { subject.call(user: user, params: params) }
          .to change(Developer::Onboarding::SurveyResponse, :count).by(1)
      end

      it 'send notify to staff' do
        expect { subject.call(user: user, params: params) }
          .to have_enqueued_job(ActionMailer::DeliveryJob)
          .with(
            'Staff::SurveyResponseCompletedMailer',
            'notify',
            'deliver_now',
            user.id
          )
      end

      it 'mark users feedback status completed' do
        expect { subject.call(user: user, params: params) }
          .to change { user.developer_onboarding.feedback_status }
          .from('feedback_pending').to('feedback_completed')
      end
    end

    context 'invalid params' do
      let(:params) do
        {
          role_id: user.role(:developer).id
        }
      end

      it 'feedback was created' do
        expect { subject.call(user: user, params: params) }
          .to change(Developer::Onboarding::SurveyResponse, :count).by(0)
      end

      it 'send notify to staff' do
        expect { subject.call(user: user, params: params) }
          .to change(ActionMailer::DeliveryJob.queue_adapter.enqueued_jobs, :size).by(0)
      end

      it 'users feedback status not changed' do
        subject.call(user: user, params: params)
        expect(user.developer_onboarding.reload.feedback_status).to eq 'feedback_pending'
      end
    end
  end
end
