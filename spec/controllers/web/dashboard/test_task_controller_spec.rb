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

  shared_examples '#new' do
    before { get :new }

    it 'renders template' do
      expect(response).to render_template :new
    end

    it 'returns success status' do
      expect(response.status).to eq 200
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
      before { login_user(user) }

      it_behaves_like '#new'
    end

    context 'mentor' do
      before { login_user(mentor) }

      it_behaves_like '#new'
    end
  end

  shared_examples '#create' do
    it 'redirect to dashboard root' do
      post :create, params: { developer_test_task: attr }
      expect(response).to redirect_to dashboard_test_tasks_url
    end

    it 'create test task' do
      expect { post :create, params: { developer_test_task: attr } }.to change(Developer::TestTask, :count).by(1)
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

    context 'authorized staff' do
      before { login_user(user) }

      it_behaves_like '#create'
    end

    context 'authorized mentor' do
      before { login_user(mentor) }

      it_behaves_like '#create'
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

  shared_examples '#edit' do
    before { get :edit, params: { id: developer_test_task.id } }

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

  describe 'GET #edit' do
    let(:developer_test_task) { create(:developer_test_task) }

    context 'authorized staff' do
      before { login_user(user) }

      it_behaves_like '#edit'
    end

    context 'authorized mentor' do
      before { login_user(mentor) }

      it_behaves_like '#edit'
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

  shared_examples '#update' do
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

  describe 'PUT #update' do
    let!(:attr) { { description: "New description_#{developer_test_task.description}" } }
    let!(:developer_test_task) { create(:developer_test_task) }

    context 'authorized staff' do
      before { login_user(user) }

      it_behaves_like '#update'
    end

    context 'authorized mentor' do
      before { login_user(user) }

      it_behaves_like '#update'
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

  shared_examples '#activate' do
    before { developer_test_task.reload }

    it 'redirect to index test tasks' do
      put :activate, params: { id: developer_test_task.id }
      expect(response).to redirect_to dashboard_test_tasks_url
    end

    it 'change state test task to activate' do
      put :activate, params: { id: developer_test_task.id }
      developer_test_task.reload
      expect(developer_test_task.state).to eq 'active'
    end
  end

  describe 'PUT #activate' do
    let!(:developer_test_task) { create(:developer_test_task, :disabled) }

    context 'not authorized' do
      before { login_user(candidate) }

      it 'redirect to dashboard root' do
        put :activate, params: { id: developer_test_task.id }
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'authorized staff' do
      before { login_user(user) }

      it_behaves_like '#activate'
    end

    context 'authorized mentor' do
      before { login_user(mentor) }

      it_behaves_like '#activate'
    end
  end

  shared_examples '#deactivate' do
    before { developer_test_task.reload }

    it 'redirect to index test tasks' do
      put :deactivate, params: { id: developer_test_task.id }
      expect(response).to redirect_to dashboard_test_tasks_url
    end

    it 'change state test task to disabled' do
      put :deactivate, params: { id: developer_test_task.id }
      developer_test_task.reload
      expect(developer_test_task.state).to eq 'disabled'
    end
  end

  describe 'PUT #deactivate' do
    let!(:developer_test_task) { create(:developer_test_task) }

    context 'not authorized' do
      before { login_user(candidate) }

      it 'redirect to dashboard root' do
        put :activate, params: { id: developer_test_task.id }
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'authorized staff' do
      before { login_user(user) }

      it_behaves_like '#deactivate'
    end

    context 'authorized mentor' do
      before { login_user(mentor) }

      it_behaves_like '#deactivate'
    end
  end
end
