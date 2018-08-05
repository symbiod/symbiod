# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::TestTaskAssignmentsController do
  describe 'GET #index' do
    # TODO: consider moving that to shared context
    context 'not signed in' do
      before { get :index }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(user)
        get :index
      end

      context 'not authorized' do
        let(:user) { create(:user, :developer, :active) }

        it 'redirects to dashboard root' do
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'staff' do
        let(:user) { create(:user, :staff) }

        it 'renders template' do
          expect(response).to render_template :index
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end

        it 'assigns candidates' do
          candidates = create_list(:user, 2, :developer, :screening_completed)
          expect(assigns(:candidates)).to match_array candidates
        end
      end

      context 'mentor' do
        let(:user) { create(:user, :mentor, :active, :with_primary_skill, skill_name: skill_name) }
        let!(:reviewable_candidates) do
          create_list(:user, 2, :developer, :screening_completed, :with_primary_skill, skill_name: skill_name)
        end
        let(:skill_name) { 'Ruby' }

        it 'renders template' do
          expect(response).to render_template :index
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end

        it 'assigns candidates' do
          expect(assigns(:candidates)).to match_array reviewable_candidates
        end
      end
    end
  end

  describe 'GET #show' do
    let(:candidate) { create(:user, :developer, :screening_completed, :with_assignment) }

    before do
      login_user(user)
      get :show, params: { id: candidate.id }
    end

    context 'authorized' do
      let(:user) { create(:user, :staff) }

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
      let(:user) { create(:user, :developer, :active) }

      it 'redirect to dashboard root' do
        expect(response).to redirect_to dashboard_root_url
      end
    end
  end

  describe 'PUT #activate' do
    let(:candidate) { create(:user, :developer, :screening_completed, :with_assignment) }
    before { login_user(user) }

    context 'authorized' do
      let(:user) { create(:user, :staff) }

      it 'calls Activate operation' do
        expect(Ops::Developer::Activate).to receive(:call).with(user: candidate, performer: user.id)
        put :activate, params: { id: candidate.id }
      end

      it 'redirects to applicants list' do
        put :activate, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_test_task_assignments_url
      end
    end

    context 'not authorized' do
      let(:user) { create(:user, :developer, :active) }

      it 'redirect to dashboard root' do
        put :activate, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_root_url
      end
    end
  end

  describe 'PUT #reject' do
    let(:candidate) { create(:user, :developer, :screening_completed, :with_assignment) }
    before { login_user(user) }

    context 'authorized' do
      let(:user) { create(:user, :staff) }

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
      let(:user) { create(:user, :developer, :active) }

      it 'redirect to dashboard root' do
        put :reject, params: { id: candidate.id, developer_test_task_assignment: { feedback: 'some text' } }
        expect(response).to redirect_to dashboard_root_url
      end
    end
  end
end
