# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::FeedbackQuestionsController, type: :controller do
  shared_examples 'redirects to landing page' do
    it 'redirects to root landing' do
      expect(response).to redirect_to root_landing_url
    end
  end

  shared_examples 'redirects to dashboard' do
    it 'redirects to dasboard' do
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

      context 'user has role staff' do
        let(:user) { create(:user, :staff, :active) }

        it 'reders template' do
          expect(response).to render_template :new
        end

        it_behaves_like 'success status'
      end

      context 'user has role not staff' do
        let(:user) { create(:user, :without_an_staff, :active) }

        it_behaves_like 'redirects to dashboard'
      end
    end
  end

  describe 'POST #create' do
    context 'not signed in' do
      let(:params) { { description: 'Description', key_name: 'Question 1' } }
      before { post :create, params: { developer_onboardin_feedback_question: params } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before { login_user(user) }

      shared_examples 'question was not created' do
        it 'question was not created' do
          expect { post :create, params: { developer_onboarding_feedback_question: params } }
            .to change(Developer::Onboarding::FeedbackQuestion, :count).by(0)
        end
      end

      context 'user has role staff' do
        let!(:user) { create(:user, :staff, :active) }

        context 'valid params' do
          let(:params) { { description: 'Description', key_name: 'Question 1' } }

          it 'question was created' do
            expect { post :create, params: { developer_onboarding_feedback_question: params } }
              .to change(Developer::Onboarding::FeedbackQuestion, :count).by(1)
          end

          it 'redirects to questions page' do
            post :create, params: { developer_onboarding_feedback_question: params }
            expect(response).to redirect_to dashboard_feedback_questions_url
          end

          it_behaves_like 'success status'
        end

        context 'invalid params' do
          let(:params) { { description: '', key_name: '' } }

          it_behaves_like 'question was not created'

          it 'renders teemplate' do
            post :create, params: { developer_onboarding_feedback_question: params }
            expect(response).to render_template :new
          end
        end
      end

      context 'user has role not staff' do
        let(:params) { { description: 'Description', key_name: 'question 1' } }
        let(:user) { create(:user, :without_an_staff, :active) }

        it_behaves_like 'question was not created'

        it 'redirects to dashboard' do
          post :create, params: { developer_onboarding_feedback_question: params }
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end

  describe 'GET #edit' do
    let!(:question) { create(:feedback_question) }

    context 'not signed in' do
      before { get :edit, params: { id: question.id } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signet in' do
      before do
        login_user(user)
        get :edit, params: { id: question.id }
      end

      context 'user has role staff' do
        let(:user) { create(:user, :staff, :active) }

        it 'redirects template' do
          expect(response).to render_template :edit
        end

        it_behaves_like 'success status'
      end

      context 'user has role  not staff' do
        let(:user) { create(:user, :without_an_staff, :active) }

        it_behaves_like 'redirects to dashboard'
      end
    end
  end

  describe 'PUT #update' do
    let!(:question) { create(:feedback_question, description: 'description') }

    context 'not signed in' do
      let(:params) { { description: 'new description' } }
      before { put :update, params: { id: question.id, developer_onboarding_feedback_question: params } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff' do
        let!(:user) { create(:user, :staff, :active) }

        context 'valid params' do
          let(:params) { { description: 'new description' } }

          it 'description field was updated' do
            expect { put :update, params: { id: question.id, developer_onboarding_feedback_question: params } }
              .to change { question.reload.description }
              .from('description')
              .to('new description')
          end

          it 'redirects to questions page' do
            put :update, params: { id: question.id, developer_onboarding_feedback_question: params }
            expect(response).to redirect_to dashboard_feedback_questions_url
          end
        end

        context 'ivalid params' do
          let(:params) { { description: '' } }
          before do
            put :update, params: { id: question.id, developer_onboarding_feedback_question: params }
          end

          it 'description field was not updated' do
            expect(question.reload.description).to eq 'description'
          end

          it 'renders template' do
            expect(response).to render_template :edit
          end
        end
      end

      context 'user has role not staff' do
        let(:user) { create(:user, :without_an_staff, :active) }
        let(:params) { { description: 'description' } }
        before do
          put :update, params: { id: question.id, developer_onboarding_feedback_question: params }
        end

        it_behaves_like 'redirects to dashboard'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:feedback_question) }

    context 'not signed in' do
      before { delete :destroy, params: { id: question.id } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff' do
        let(:user) { create(:user, :staff, :active) }

        it 'question was deleted' do
          expect { delete :destroy, params: { id: question.id } }
            .to change(Developer::Onboarding::FeedbackQuestion, :count).by(-1)
        end

        it 'redirects to questions page' do
          delete :destroy, params: { id: question.id }
          expect(response).to redirect_to dashboard_feedback_questions_url
        end
      end

      context 'user has role not staff' do
        let(:user) { create(:user, :without_an_staff, :active) }
        before { delete :destroy, params: { id: question.id } }

        it_behaves_like 'redirects to dashboard'
      end
    end
  end
end
