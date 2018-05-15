# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::TestTasksController do
  let(:user) { create(:user, :staff) }

  describe 'GET #index' do
    context 'not signed in' do
      before { get :index }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_url(subdomain: 'www')
      end
    end

    context 'not authorized' do
      let(:candidate) { create(:user, :active) }
      before do
        login_user(candidate)
        get :index
      end

      it 'redirects to dashboard root' do
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'staff' do
      before do
        login_user(user)
        get :index
      end

      it 'renders template' do
        expect(response).to render_template :index
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET #edit' do
    context 'authorized' do
      let(:developer_test_task) { create(:developer_test_task) }
      before do
        login_user(user)
        get :edit, params: { id: developer_test_task.id }
      end

      it 'renders template' do
        expect(response).to render_template :edit
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end

      it 'assigns developer test task' do
        expect(assigns(:developer_test_task)).to eq developer_test_task
      end
    end

    context 'not authorized' do
      let!(:developer_test_task) { create(:developer_test_task) }
      let!(:candidate) { create(:user, :active) }
      before do
        login_user(candidate)
        get :edit, params: { id: developer_test_task.id }
      end

      it 'redirect to dashboard root' do
        expect(response).to redirect_to dashboard_root_url
      end
    end
  end

  describe 'PUT #update' do
    let!(:developer_test_task) { create(:developer_test_task) }
    let!(:attr) { { description: "New description_#{developer_test_task.description}" } }

    context 'authorized' do
      before { login_user(user) }

      it 'updates attribute' do
        put :update, params: { id: developer_test_task.id, developer_test_task: attr }
        developer_test_task.reload
        expect(developer_test_task.description).to eq attr[:description]
      end

      it 'redirects to index test task' do
        put :update, params: { id: developer_test_task.id, developer_test_task: attr }
        expect(response).to redirect_to dashboard_test_tasks_url
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :active) }
      let!(:actual) { developer_test_task.description }
      before { login_user(candidate) }

      it 'redirect to dashboard root' do
        put :update, params: { id: developer_test_task.id, developer_test_task: attr }
        expect(response).to redirect_to dashboard_root_url
      end

      it 'test task not updated' do
        put :update, params: { id: developer_test_task.id, developer_test_task: attr }
        developer_test_task.reload
        expect(developer_test_task.description).to eq actual
      end
    end

    context 'not passed validations' do
      let!(:attr) { { description: 'New description' } }
      let!(:actual) { developer_test_task.description }
      before { login_user(user) }

      it 'renders template' do
        put :update, params: { id: developer_test_task.id, developer_test_task: attr }
        expect(response).to render_template :edit
      end

      it 'test task not updated' do
        put :update, params: { id: developer_test_task.id, developer_test_task: attr }
        developer_test_task.reload
        expect(developer_test_task.description).to eq actual
      end
    end
  end
end
