# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::SurveyResponsesController, type: :controller do
  before { create(:feedback_question) }
  let!(:question) { ::Developer::Onboarding::FeedbackQuestion.first }

  shared_examples 'redirects to landing page' do
    it 'redirects to root landing' do
      expect(response).to redirect_to root_landing_url
    end
  end

  shared_examples 'redirects to dashboard' do
    it 'redirects to dashboard' do
      expect(response).to redirect_to dashboard_root_url
    end
  end

  shared_examples 'success status' do
    it 'returns success status' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET #index' do
    context 'not signed in' do
      before { get :index }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before do
        login_user(user)
        get :index
      end

      context 'user has role staff' do
        let(:user) { create(:user, :staff, :active) }

        it 'renders template' do
          expect(response).to render_template :index
        end

        it_behaves_like 'success status'
      end

      context 'user has role not staff' do
        let(:user) { create(:user, :without_an_staff, :active) }

        it_behaves_like 'redirects to dashboard'
      end
    end
  end

  describe 'GET #show' do
    let(:feedback) { create(:survey_response, "#{question.key_name}": 'Answer 1') }

    context 'not signed in' do
      before { get :show, params: { id: feedback.id } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before do
        login_user(user)
        get :show, params: { id: feedback.id }
      end

      context 'user has role staff' do
        let(:user) { create(:user, :staff, :active) }

        it 'renders template' do
          expect(response).to render_template :show
        end

        it_behaves_like 'success status'
      end

      context 'user has role not staff' do
        let(:user) { create(:user, :without_an_staff, :active) }

        it_behaves_like 'redirects to dashboard'
      end
    end
  end

  describe 'GET #new' do
    context 'not signed in' do
      before { get :new }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before do
        login_user(user)
      end

      context 'user has not feedback' do
        let(:user) { create(:user, :sample_role, :active) }
        before { get :new }

        it 'renders template' do
          expect(response).to render_template :new
        end

        it_behaves_like 'success status'
      end

      context 'user has feedback' do
        let(:user) { create(:user, :sample_role, :active) }
        before do
          create(:survey_response, user: user, "#{question.key_name}": 'Answer 1')
          get :new
        end

        it_behaves_like 'redirects to dashboard'
      end
    end
  end

  describe 'POST #create' do
    context 'not signed in' do
      let(:user) { create(:user, :sample_role, :active) }
      let(:params) do
        {
          user_id: user.id,
          "#{question.key_name}": 'Answer 1'
        }
      end
      before { post :create, params: { developer_onboarding_survey_response: params } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before do
        login_user(user)
      end

      context 'user has not feedback' do
        let!(:user) { create(:user, :sample_role, :active) }

        context 'valid params' do
          let(:params) do
            {
              user_id: user.id,
              "#{question.key_name}": 'Answer 1'
            }
          end

          it 'run send email' do
            expect { post :create, params: { developer_onboarding_survey_response: params } }
              .to have_enqueued_job(ActionMailer::DeliveryJob)
              .with(
                'Staff::SurveyResponseCompletedMailer',
                'notify',
                'deliver_now',
                user.id
              )
          end

          it 'created survey response' do
            expect { post :create, params: { developer_onboarding_survey_response: params } }
              .to change(::Developer::Onboarding::SurveyResponse, :count).by(1)
          end

          it 'redirects to dashboard' do
            post :create, params: { developer_onboarding_survey_response: params }
            expect(response).to redirect_to dashboard_root_url
          end
        end

        context 'invalid params' do
          let(:params) do
            {
              user_id: user.id,
              "#{question.key_name}": ''
            }
          end

          it 'renders template' do
            post :create, params: { developer_onboarding_survey_response: params }
            expect(response).to render_template :new
          end
        end
      end

      context 'user has feedback' do
        let(:user) { create(:user, :sample_role, :active) }
        let(:feedback) { create(:survey_response, user: user, "#{question.key_name}": 'Answer 1') }
        let(:params) do
          {
            user_id: user.id,
            "#{question.key_name}": 'Answer 1'
          }
        end
        before { post :create, params: { developer_onboarding_survey_response: params } }

        it_behaves_like 'redirects to dashboard'
      end
    end
  end
end
