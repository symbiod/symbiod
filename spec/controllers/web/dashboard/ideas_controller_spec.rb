# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Dashboard::IdeasController, type: :controller do
  shared_examples 'dashboard idea #index tests' do
    it 'renders template' do
      expect(response).to render_template :index
    end

    it 'returns success status' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET #index' do
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

      context 'user has role staff or mentor' do
        let(:user) { create(:user, %i[staff mentor].sample, :active) }

        it_behaves_like 'dashboard idea #index tests'

        it 'assigns all ideas' do
          create_list(:idea, 10, :all_states)
          expect(assigns(:ideas)).to eq Idea.all.page 1
        end
      end

      context 'user has role developer' do
        let(:user) { create(:user, :developer, :active) }

        it_behaves_like 'dashboard idea #index tests'

        it 'assigns activated ideas' do
          create_list(:idea, 10, :all_states)
          expect(assigns(:ideas)).to eq Idea.activated.page 1
        end
      end

      context 'user has role author' do
        let(:user) { create(:user, :author, :active) }
        let(:idea) { create(:idea, author: user) }

        it_behaves_like 'dashboard idea #index tests'

        it 'assigns activated and current user ideas' do
          create_list(:idea, 10, :all_states)
          expect(assigns(:ideas)).to eq Idea.where(author_id: user.id).page 1
        end
      end

      context 'user has roles author and developer' do
        let(:user) { create(:user, :developer, :author, :active) }
        let(:idea) { create(:idea, author: user) }

        it_behaves_like 'dashboard idea #index tests'

        it 'assigns active and current user ideas' do
          create_list(:idea, 10, :all_states)
          expect(assigns(:ideas)).to eq Idea.where('author_id = ? OR state = ?', user.id, 'active').page 1
        end
      end
    end
  end

  shared_examples 'dashboard idea #show tests' do
    it 'renders template' do
      expect(response).to render_template :show
    end

    it 'returns success status' do
      expect(response.status).to eq 200
    end

    it 'assigns idea' do
      expect(assigns(:idea)).to eq idea
    end
  end

  describe 'GET #show' do
    let(:idea) { create(:idea) }

    context 'not signed in' do
      before { get :show, params: { id: idea.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(user)
        get :show, params: { id: idea.id }
      end

      context 'user has role staff or mentor' do
        let(:user) { create(:user, %i[staff mentor].sample, :active) }

        it_behaves_like 'dashboard idea #show tests'
      end

      context 'user has role developer' do
        let(:user) { create(:user, :developer, :active) }

        it_behaves_like 'dashboard idea #show tests'
      end

      context 'user has role author' do
        let(:user) { create(:user, :author, :active) }

        it_behaves_like 'dashboard idea #show tests'
      end
    end
  end

  shared_examples 'dashboard idea #new tests' do
    it 'renders template' do
      expect(response).to render_template :new
    end

    it 'returns success status' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET #new' do
    context 'not signed in' do
      before { get :new }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(user)
        get :new
      end

      context 'user has role staff or mentor' do
        let(:user) { create(:user, %i[staff mentor].sample, :active) }

        it_behaves_like 'dashboard idea #new tests'
      end

      context 'user has role developer' do
        let(:user) { create(:user, :developer, :active) }

        it 'redirects to dashboard root' do
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'user has role author' do
        let(:user) { create(:user, :author, :active) }

        it_behaves_like 'dashboard idea #new tests'
      end
    end
  end

  shared_examples 'dashboard idea #create tests' do
    it 'redirect to dashboard ideas' do
      post :create, params: { idea: idea_params }
      expect(response).to redirect_to dashboard_ideas_url
    end

    it 'returns success status' do
      expect { post :create, params: { idea: idea_params } }.to change(::Idea, :count).by(1)
    end
  end

  describe 'GET #create' do
    let(:idea_params) do
      {
        name: 'Title',
        description: 'Description'
      }
    end

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { post :create, params: { idea: idea_params } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, %i[staff mentor].sample, :active) }

        it_behaves_like 'dashboard idea #create tests'
      end

      context 'user has role developer' do
        let(:user) { create(:user, :developer, :active) }

        it 'redirects to dashboard root' do
          post :create, params: { idea: idea_params }
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'user has role author' do
        let(:user) { create(:user, :author, :active) }

        it_behaves_like 'dashboard idea #create tests'
      end

      context 'not passed validation' do
        let(:user) { create(:user, :staff, :active) }
        let!(:idea_params) do
          {
            description: 'not passed validation'
          }
        end

        it 'render new' do
          post :create, params: { idea: idea_params }
          expect(response).to render_template :new
        end
      end
    end
  end

  shared_examples 'dashboard idea #edit tests' do
    it 'renders template' do
      expect(response).to render_template :edit
    end

    it 'returns success status' do
      expect(response.status).to eq 200
    end

    it 'assigns idea' do
      expect(assigns(:idea)).to eq idea
    end
  end

  describe 'GET #edit' do
    let(:idea) { create(:idea) }

    context 'not signed in' do
      before { get :edit, params: { id: idea.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(user)
        get :edit, params: { id: idea.id }
      end

      context 'user has role staff or mentor' do
        let(:user) { create(:user, %i[staff mentor].sample, :active) }

        it_behaves_like 'dashboard idea #edit tests'
      end

      context 'user has role developer' do
        let(:user) { create(:user, :developer, :active) }

        it 'redirects to dashboard root' do
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'user has role author' do
        let(:user) { create(:user, :author, :active) }

        it_behaves_like 'dashboard idea #edit tests'
      end
    end
  end

  shared_examples 'dashboard idea #update tests' do
    it 'updates attribute' do
      put :update, params: { id: idea.id, idea: new_idea_params }
      idea.reload
      expect(idea.description).to eq new_idea_params[:description]
    end

    it 'redirects to dashboard ideas' do
      put :update, params: { id: idea.id, idea: new_idea_params }
      expect(response).to redirect_to dashboard_idea_url(idea)
    end
  end

  describe 'GET #update' do
    let(:idea) { create(:idea) }
    let(:new_idea_params) do
      {
        name: 'New Title',
        description: 'New Description'
      }
    end

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :update, params: { id: idea.id, idea: new_idea_params } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, %i[staff mentor].sample, :active) }

        it_behaves_like 'dashboard idea #update tests'
      end

      context 'user has role developer' do
        let(:user) { create(:user, :developer, :active) }

        it 'redirects to dashboard root' do
          put :update, params: { id: idea.id, idea: new_idea_params }
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'user has role author' do
        let(:user) { create(:user, :author, :active) }

        it_behaves_like 'dashboard idea #update tests'
      end

      context 'not passed validation' do
        let(:user) { create(:user, :staff, :active) }
        let!(:new_idea_params) do
          {
            description: nil
          }
        end

        it 'render edit' do
          put :update, params: { id: idea.id, idea: new_idea_params }
          expect(response).to render_template :edit
        end
      end
    end
  end

  shared_examples 'dashboard idea #activate tests' do
    it 'redirects to dashboard ideas' do
      put :activate, params: { id: idea.id }
      idea.reload
      expect(idea.state).to eq 'active'
    end

    it 'redirects to dashboard ideas' do
      put :activate, params: { id: idea.id }
      expect(response).to redirect_to dashboard_idea_url(idea)
    end
  end

  describe 'GET #activate' do
    let(:idea) { create(:idea, %i[disabled pending].sample) }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :activate, params: { id: idea.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, %i[staff mentor].sample, :active) }

        it_behaves_like 'dashboard idea #activate tests'
      end

      context 'user has role developer' do
        let(:user) { create(:user, :developer, :active) }

        it 'redirects to dashboard root' do
          put :activate, params: { id: idea.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'user has role author' do
        let(:user) { create(:user, :author, :active) }

        it 'redirects to dashboard root' do
          put :activate, params: { id: idea.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end

  shared_examples 'dashboard idea #deactivate tests' do
    it 'redirects to dashboard ideas' do
      put :deactivate, params: { id: idea.id }
      idea.reload
      expect(idea.state).to eq 'disabled'
    end

    it 'redirects to dashboard ideas' do
      put :deactivate, params: { id: idea.id }
      expect(response).to redirect_to dashboard_idea_url(idea)
    end
  end

  describe 'GET #deactivate' do
    let(:idea) { create(:idea, :active) }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :deactivate, params: { id: idea.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, %i[staff mentor].sample, :active) }

        it_behaves_like 'dashboard idea #deactivate tests'
      end

      context 'user has role developer' do
        let(:user) { create(:user, :developer, :active) }

        it 'redirects to dashboard root' do
          put :deactivate, params: { id: idea.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'user has role author' do
        let(:user) { create(:user, :author, :active) }

        it 'redirects to dashboard root' do
          put :deactivate, params: { id: idea.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end

  shared_examples 'dashboard idea #reject tests' do
    it 'redirects to dashboard ideas' do
      put :reject, params: { id: idea.id }
      idea.reload
      expect(idea.state).to eq 'rejected'
    end

    it 'redirects to dashboard ideas' do
      put :reject, params: { id: idea.id }
      expect(response).to redirect_to dashboard_idea_url(idea)
    end
  end

  describe 'GET #reject' do
    let(:idea) { create(:idea, :pending) }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :reject, params: { id: idea.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, %i[staff mentor].sample, :active) }

        it_behaves_like 'dashboard idea #reject tests'
      end

      context 'user has role developer' do
        let(:user) { create(:user, :developer, :active) }

        it 'redirects to dashboard root' do
          put :reject, params: { id: idea.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'user has role author' do
        let(:user) { create(:user, :author, :active) }

        it 'redirects to dashboard root' do
          put :reject, params: { id: idea.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end
end
