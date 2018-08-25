# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::ProjectsController, type: :controller do
  describe 'GET #index' do
    shared_examples '#index' do
      it 'renders template' do
        expect(response).to render_template :index
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end

    context 'not signed in' do
      before { get :index }

      it 'redirects to root landing page' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(user)
        get :index
      end

      context 'current user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it_behaves_like '#index'
      end

      context 'current user has role member or author' do
        let(:user) { create(:user, :member_or_author, :active) }

        it_behaves_like '#index'
      end
    end
  end

  describe 'GET #show' do
    shared_examples '#show' do
      it 'renders template' do
        expect(response).to render_template :show
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end

    context 'not signed in' do
      before { get :show, params: { id: idea.project.id } }
      let(:idea) { create(:idea, :with_project) }

      it 'redirects to root landing page' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(user)
        get :show, params: { id: idea.project.id }
      end

      context 'current user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }
        let(:idea) { create(:idea, :with_project) }

        it_behaves_like '#show'
      end

      context 'current user has role member' do
        let!(:user) { create(:user, :member, :active) }
        let!(:idea) { create(:idea, :with_project) }

        context 'user member project' do
          before do
            create(:project_user, user: user, project: idea.project)
            login_user(user)
            get :show, params: { id: idea.project.id }
          end

          it_behaves_like '#show'
        end

        context 'user not member project' do
          it 'redirects to dashboard' do
            expect(response).to redirect_to dashboard_root_url
          end
        end
      end

      context 'current user has role author' do
        let!(:user) { create(:user, :author, :active) }

        context 'user author project' do
          let(:idea) { create(:idea, :with_project, author: user) }

          it_behaves_like '#show'
        end

        context 'user not author project' do
          let(:idea) { create(:idea, :with_project) }

          it 'redirects to dashboard' do
            expect(response).to redirect_to dashboard_root_url
          end
        end
      end
    end
  end

  describe 'GET #edit' do
    shared_examples '#edit' do
      it 'renders template' do
        expect(response).to render_template :edit
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end

    context 'not signed in' do
      before { get :edit, params: { id: idea.project.id } }
      let(:idea) { create(:idea, :with_project) }

      it 'redirects to root landing page' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(user)
        get :edit, params: { id: idea.project.id }
      end

      context 'current user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }
        let(:idea) { create(:idea, :with_project) }

        it_behaves_like '#edit'
      end

      context 'current user has role member' do
        let!(:user) { create(:user, :member, :active) }
        let!(:idea) { create(:idea, :with_project) }

        context 'user member project' do
          before do
            create(:project_user, user: user, project: idea.project)
            login_user(user)
            get :edit, params: { id: idea.project.id }
          end

          it 'redirects to dashboard' do
            expect(response).to redirect_to dashboard_root_url
          end
        end

        context 'user not member project' do
          it 'redirects to dashboard' do
            expect(response).to redirect_to dashboard_root_url
          end
        end
      end

      context 'current user has role author' do
        let!(:user) { create(:user, :author, :active) }

        context 'user author project' do
          let(:idea) { create(:idea, :with_project, author: user) }

          it_behaves_like '#edit'
        end

        context 'user not author project' do
          let(:idea) { create(:idea, :with_project) }

          it 'redirects to dashboard' do
            expect(response).to redirect_to dashboard_root_url
          end
        end
      end
    end
  end

  describe 'PUT #update' do
    let!(:new_project_params) { { name: 'new name' } }
    let!(:invalid_project_params) { { name: '' } }

    shared_examples '#update valid params' do
      it 'update attribute' do
        put :update, params: { id: idea.project.id, project: new_project_params }
        expect(idea.project.reload.name).to eq new_project_params[:name]
      end

      it 'redirects to project page' do
        put :update, params: { id: idea.project.id, project: new_project_params }
        expect(response).to redirect_to dashboard_project_url(idea.project)
      end
    end

    shared_examples '#update invalid params' do
      it 'update attribute' do
        put :update, params: { id: idea.project.id, project: invalid_project_params }
        expect(idea.project.reload.name).not_to eq invalid_project_params[:name]
      end

      it 'renders template' do
        put :update, params: { id: idea.project.id, project: invalid_project_params }
        expect(response).to render_template :edit
      end
    end

    context 'not signed in' do
      before { put :update, params: { id: idea.project.id, project: new_project_params } }
      let(:idea) { create(:idea, :with_project) }

      it 'redirects to root landing page' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'current user has role staff or mentor' do
        let!(:user) { create(:user, :staff_or_mentor, :active) }
        let!(:idea) { create(:idea, :with_project) }

        context 'project have valid params' do
          it_behaves_like '#update valid params'
        end

        context 'project have invalid params' do
          it_behaves_like '#update invalid params'
        end
      end

      context 'current user has role member' do
        let!(:user) { create(:user, :member, :active) }
        let!(:idea) { create(:idea, :with_project) }

        context 'user member project' do
          before do
            create(:project_user, user: user, project: idea.project)
            login_user(user)
          end

          it 'redirects to dashboard' do
            put :update, params: { id: idea.project.id, project: new_project_params }
            expect(response).to redirect_to dashboard_root_url
          end
        end

        context 'user not member project' do
          it 'redirects to dashboard' do
            put :update, params: { id: idea.project.id, project: new_project_params }
            expect(response).to redirect_to dashboard_root_url
          end
        end
      end

      context 'current user has role author' do
        let!(:user) { create(:user, :author, :active) }

        context 'user author project' do
          let!(:idea) { create(:idea, :with_project, author: user) }

          context 'project have valid params' do
            it_behaves_like '#update valid params'
          end

          context 'project have invalid params' do
            it_behaves_like '#update invalid params'
          end
        end

        context 'user not author project' do
          let(:idea) { create(:idea, :with_project) }

          it 'redirects to dashboard' do
            put :update, params: { id: idea.project.id, project: new_project_params }
            expect(response).to redirect_to dashboard_root_url
          end
        end
      end
    end
  end
end
