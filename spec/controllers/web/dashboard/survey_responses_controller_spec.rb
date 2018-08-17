# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::SurveyResponsesController, type: :controller do
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

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'renders template' do
          expect(response).to render_template :index
        end

        it_behaves_like 'success status'
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it_behaves_like 'redirects to dashboard'
      end
    end
  end

  describe 'GET #show' do
    let(:feedback) { create(:survey_response) }

    context 'not signed in' do
      before { get :show, params: { id: feedback.id } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before do
        login_user(user)
        get :show, params: { id: feedback.id }
      end

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'renders template' do
          expect(response).to render_template :show
        end

        it_behaves_like 'success status'
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

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
        get :new
      end

      context 'user has not feedback' do
        let(:user) { create(:user, :sample_role, :active) }

        it 'renders template' do
          expect(response).to render_template :new
        end

        it_behaves_like 'success status'
      end

      context 'user has feedback' do
        let(:user) { create(:user, :with_feedback, :sample_role, :active) }

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
          question_1: 'Answer 1',
          question_2: 'Answer 2'
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
          let(:result_double) { double(success?: true) }
          let(:params) do
            {
              user_id: user.id,
              question_1: 'Answer 1',
              question_2: 'Answer 2'
            }
          end

          it 'run operation' do
            expect(Ops::Developer::Onboarding::SubmitSurveyResponse)
              .to receive(:call)
              .with(any_args)
              .and_return(result_double)
            post :create, params: { developer_onboarding_survey_response: params }
          end

          it 'redirects to dashboard' do
            post :create, params: { developer_onboarding_survey_response: params }
            expect(response).to redirect_to dashboard_root_url
          end
        end

        context 'invalid params' do
          let(:result_double) { double(success?: false) }
          let(:params) do
            {
              user_id: user.id,
              question_1: '',
              question_2: 'Answer 2'
            }
          end

          it 'run operation' do
            allow(result_double).to receive(:[])
            expect(Ops::Developer::Onboarding::SubmitSurveyResponse)
              .to receive(:call)
              .with(any_args)
              .and_return(result_double)
            post :create, params: { developer_onboarding_survey_response: params }
          end

          it 'renders template' do
            post :create, params: { developer_onboarding_survey_response: params }
            expect(response).to render_template :new
          end
        end
      end

      context 'user has feedback' do
        let(:user) { create(:user, :with_feedback, :sample_role, :active) }
        let(:params) do
          {
            user_id: user.id,
            question_1: 'Answer 1',
            question_2: 'Answer 2'
          }
        end
        before { post :create, params: { developer_onboarding_survey_response: params } }

        it_behaves_like 'redirects to dashboard'
      end
    end
  end
end
