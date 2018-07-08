# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::TestTasksController do
  describe 'GET #index' do
    context 'not signed in' do
      before { get :index }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'sign in' do
      before do
        login_user(user)
        get :index
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'renders template' do
          expect(response).to render_template :index
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end

        it 'assigns all test tasks' do
          create_list(:developer_test_task, 10)
          expect(assigns(:developer_test_tasks)).to eq Developer::TestTask.order(id: :asc)
        end
      end
    end
  end

  describe 'GET #new' do
    context 'not signed in' do
      before { get :new }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'sign in' do
      before do
        login_user(user)
        get :new
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'renders template' do
          expect(response).to render_template :new
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end
      end
    end
  end

  describe 'POST #create' do
    let!(:skill) { create(:skill) }
    let!(:role) { create(:role) }
    let(:test_task_params) do
      {
        position: 1,
        title: Faker::VForVendetta.quote,
        description: Faker::VForVendetta.speech,
        role_name: role.name,
        skill_id: skill.id
      }
    end

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { post :create, params: { developer_test_task: test_task_params } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'redirect to dashboard test tasks' do
          post :create, params: { developer_test_task: test_task_params }
          expect(response).to redirect_to dashboard_test_tasks_url
        end

        it 'returns success status' do
          expect { post :create, params: { developer_test_task: test_task_params } }
            .to change(Developer::TestTask, :count).by(1)
        end
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          post :create, params: { developer_test_task: test_task_params }
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'not passed validation' do
        let(:user) { create(:user, :staff, :active) }
        let!(:test_task_params) do
          {
            position: 1,
            title: Faker::VForVendetta.quote,
            description: nil,
            role_name: role.name,
            skill_id: skill.id
          }
        end

        it 'renders new' do
          post :create, params: { developer_test_task: test_task_params }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'GET #edit' do
    let(:developer_test_task) { create(:developer_test_task) }

    context 'not signed in' do
      before { get :edit, params: { id: developer_test_task.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(user)
        get :edit, params: { id: developer_test_task.id }
      end

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'renders template' do
          expect(response).to render_template :edit
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end

        it 'assigns test task' do
          expect(assigns(:developer_test_task)).to eq developer_test_task
        end
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:developer_test_task) { create(:developer_test_task) }
    let(:new_test_task_params) do
      {
        description: "New description_#{developer_test_task.description}"
      }
    end

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :update, params: { id: developer_test_task.id, developer_test_task: new_test_task_params } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'updates attribute' do
          put :update, params: { id: developer_test_task.id, developer_test_task: new_test_task_params }
          expect(developer_test_task.reload.description).to eq new_test_task_params[:description]
        end

        it 'redirects to dashboard test tasks' do
          put :update, params: { id: developer_test_task.id, developer_test_task: new_test_task_params }
          expect(response).to redirect_to dashboard_test_tasks_url
        end
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          put :update, params: { id: developer_test_task.id, developer_test_task: new_test_task_params }
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'not passed validation' do
        let(:user) { create(:user, :staff, :active) }
        let!(:new_test_task_params) do
          {
            description: nil
          }
        end

        it 'renders edit' do
          put :update, params: { id: developer_test_task.id, developer_test_task: new_test_task_params }
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'PUT #activate' do
    let(:developer_test_task) { create(:developer_test_task, :disabled) }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :activate, params: { id: developer_test_task.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'the test task became active' do
          expect { put :activate, params: { id: developer_test_task.id } }
            .to change { developer_test_task.reload.state }.from('disabled').to('active')
        end

        it 'redirects to dashboard test tasks' do
          put :activate, params: { id: developer_test_task.id }
          expect(response).to redirect_to dashboard_test_tasks_url
        end
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          put :activate, params: { id: developer_test_task.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end

  describe 'PUT #deactivate' do
    let!(:developer_test_task) { create(:developer_test_task) }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :deactivate, params: { id: developer_test_task.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'the test task became disabled' do
          expect { put :deactivate, params: { id: developer_test_task.id } }
            .to change { developer_test_task.reload.state }.from('active').to('disabled')
        end

        it 'redirects to dashboard test tasks' do
          put :deactivate, params: { id: developer_test_task.id }
          expect(response).to redirect_to dashboard_test_tasks_url
        end
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          put :deactivate, params: { id: developer_test_task.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end
end
