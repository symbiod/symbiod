# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::TestTasksController do
  let(:user) { create(:user, :staff) }
  let(:candidate) { create(:user, :active) }
  let(:mentor) { create(:user, :active, :mentor) }

  describe 'GET #index' do
    context 'not signed in' do
      before { get :index }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'not authorized' do
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

  describe 'GET #new' do
    context 'not authorized' do
      before do
        login_user(candidate)
        get :new
      end

      it 'redirects to dashboard root' do
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'staff' do
      before do
        login_user(user)
        get :new
      end

      it 'redirects to dashboard root' do
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'mentor' do
      let(:mentor) { create(:user, :active, :mentor) }
      before do
        login_user(mentor)
        get :new
      end

      it 'renders template' do
        expect(response).to render_template :new
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'POST #create' do
    let!(:attr) do
      {
        position: 1,
        title: Faker::VForVendetta.quote,
        description: Faker::VForVendetta.speech,
        role_id: 22
      }
    end
    let(:developer_test_task) { Developer::TestTask.new }

    context 'not authorized' do
      before { login_user(candidate) }

      it 'redirect to dashboard root' do
        post :create, params: { developer_test_task: attr }
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'authorized' do
      before { login_user(user) }

      it 'redirect to dashboard root' do
        post :create, params: { developer_test_task: attr }
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'success create test task' do
      before { login_user(mentor) }

      it 'redirect to index test tasks' do
        post :create, params: { developer_test_task: attr }
        expect(response).to redirect_to dashboard_test_tasks_url
      end

      it 'create test task' do
        expect { post :create, params: { developer_test_task: attr } }.to change(Developer::TestTask, :count).by(1)
      end
    end

    context 'not passed validation' do
      let!(:attr) do
        {
          position: 1,
          title: Faker::VForVendetta.quote,
          description: 'not passed validation',
          role_id: 22
        }
      end
      before { login_user(mentor) }

      it 'render new' do
        post :create, params: { developer_test_task: attr }
        expect(response).to render_template :new
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

  describe 'DELETE #destroy' do
    let(:developer_test_task) { create(:developer_test_task) }
    before { developer_test_task.reload }

    context 'not authorized' do
      before { login_user(candidate) }

      it 'redirect to dashboard root' do
        delete :destroy, params: { id: developer_test_task.id }
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'authorized' do
      before { login_user(user) }

      it 'redirect to dashboard root' do
        delete :destroy, params: { id: developer_test_task.id }
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'success destroy test task' do
      before { login_user(mentor) }

      it 'delete test task' do
        expect { delete :destroy, params: { id: developer_test_task.id } }.to change(Developer::TestTask, :count).by(-1)
      end

      it 'redirect to index test tasks' do
        delete :destroy, params: { id: developer_test_task.id }
        expect(response).to redirect_to dashboard_test_tasks_url
      end
    end
  end
end
