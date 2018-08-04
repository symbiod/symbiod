# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Dashboard::SkillsController, type: :controller do
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
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'renders template' do
          expect(response).to render_template :index
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end

        it 'assigns all skills' do
          create_list(:skill, 10)
          expect(assigns(:skills)).to eq Skill.order(id: :desc)
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
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'renders template' do
          expect(response).to render_template :new
        end

        it 'returns success status' do
          expect(response.status).to eq 200
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

  describe 'POST #create' do
    let(:skill_params) { { title: 'Title' } }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { post :create, params: { skill: skill_params } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'redirect to dashboard skills' do
          post :create, params: { skill: skill_params }
          expect(response).to redirect_to dashboard_skills_url
        end

        it 'returns success status' do
          expect { post :create, params: { skill: skill_params } }.to change(Skill, :count).by(1)
        end
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          post :create, params: { skill: skill_params }
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'not passed validation' do
        let(:user) { create(:user, :staff, :active) }
        let!(:skill_params) do
          {
            title: nil
          }
        end

        it 'renders new' do
          post :create, params: { skill: skill_params }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'GET #edit' do
    let(:skill) { create(:skill) }

    context 'not signed in' do
      before { get :edit, params: { id: skill.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(user)
        get :edit, params: { id: skill.id }
      end

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'renders template' do
          expect(response).to render_template :edit
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end

        it 'assigns skill' do
          expect(assigns(:skill)).to eq skill
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

  describe 'GET #update' do
    let(:skill) { create(:skill) }
    let(:new_skill_params) { { title: 'New Title' } }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :update, params: { id: skill.id, skill: new_skill_params } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'updates attribute' do
          put :update, params: { id: skill.id, skill: new_skill_params }
          skill.reload
          expect(skill.title).to eq new_skill_params[:title]
        end

        it 'redirects to dashboard skills' do
          put :update, params: { id: skill.id, skill: new_skill_params }
          expect(response).to redirect_to dashboard_skills_url
        end
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          put :update, params: { id: skill.id, skill: new_skill_params }
          expect(response).to redirect_to dashboard_root_url
        end
      end

      context 'not passed validation' do
        let(:user) { create(:user, :staff, :active) }
        let!(:new_skill_params) do
          {
            title: nil
          }
        end

        it 'render edit' do
          put :update, params: { id: skill.id, skill: new_skill_params }
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'GET #activate' do
    let(:skill) { create(:skill, :disabled) }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :activate, params: { id: skill.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'the skill became active' do
          expect { put :activate, params: { id: skill.id } }
            .to change { skill.reload.state }.from('disabled').to('active')
        end

        it 'redirects to dashboard skills' do
          put :activate, params: { id: skill.id }
          expect(response).to redirect_to dashboard_skills_url
        end
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          put :activate, params: { id: skill.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end

  describe 'GET #deactivate' do
    let(:skill) { create(:skill, :active) }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :deactivate, params: { id: skill.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'the skill became disabled' do
          expect { put :deactivate, params: { id: skill.id } }
            .to change { skill.reload.state }.from('active').to('disabled')
        end

        it 'redirects to dashboard skills' do
          put :deactivate, params: { id: skill.id }
          expect(response).to redirect_to dashboard_skills_url
        end
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it 'redirects to dashboard root' do
          put :deactivate, params: { id: skill.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end
end
