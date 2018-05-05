# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::TestTaskAssignmentsController do
  let(:user) { create(:user, :staff) }

  describe 'GET #index' do
    context 'not signed in' do
      before { get :index }

      it 'redirects to root landing' do
        expect(response).to redirect_to '/'
      end
    end

    context 'not authorized' do
      let(:user) { create(:user, :active) }
      before { get :index }

      it 'redirects to dashboard root' do
        expect(response).to redirect_to dashboard_root_path
      end
    end

    context 'staff' do
      before { login_user(user) }
      before { get :index }

      it 'renders template' do
        expect(response).to render_template :index
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end

      it 'assigns candidates' do
        create_list(:user, 2, :screening_completed)
        expect(assigns(:candidates)).to eq User.screening_completed
      end
    end
  end

  describe 'GET #show' do
    context 'authorized' do
      let!(:candidate) { create(:user, :screening_completed) }
      before { login_user(user) }
      before { get :show, params: { id: candidate.id } }

      it 'renders template' do
        expect(response).to render_template :show
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end

      it 'assigns candidate' do
        expect(assigns(:candidate)).to eq candidate
      end
    end

    context 'not authorized' do
      pending 'Add some tests here'
    end
  end

  describe 'PUT #activate' do
    context 'authorized' do
      let!(:candidate) { create(:user, :screening_completed) }
      before { login_user(user) }

      it 'calls Activate operation' do
        expect(Ops::Developer::Activate).to receive(:call).with(user: candidate)
        put :activate, params: { id: candidate.id }
      end

      it 'redirects to applicants list' do
        put :activate, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_test_task_assignments_url
      end
    end

    context 'not authorized' do
      pending 'Add some tests here'
    end
  end

  describe 'PUT #reject' do
    context 'authorized' do
      let!(:candidate) { create(:user, :screening_completed, :with_assignment) }
      before { login_user(user) }

      it 'calls Reject operation' do
        expect(Ops::Developer::Reject).to receive(:call).with(user: candidate, feedback: '')
        put :reject, params: { id: candidate.id, developer_test_task_assignment: { feedback: '' } }
      end

      it 'redirects to applicants list' do
        put :reject, params: { id: candidate.id, developer_test_task_assignment: { feedback: 'some text' } }
        expect(response).to redirect_to dashboard_test_task_assignments_url
      end
    end

    context 'not authorized' do
      pending 'Add some tests here'
    end
  end
end
