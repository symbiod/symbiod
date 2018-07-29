# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Dashboard::UsersController, type: :controller do
  let(:user) { create(:user, :staff) }

  describe 'GET #index' do
    context 'not signed in' do
      before { get :index }

      it 'redirect to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :developer, :active) }
      before do
        login_user(candidate)
        get :index
      end

      it 'render template' do
        expect(response).to render_template :index
      end

      it 'returns success status' do
        expect(response.status).to eq 200
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

  describe 'GET #show' do
    context 'authorized' do
      let!(:candidate) { create(:user, :developer, :screening_completed) }
      before do
        login_user(user)
        get :show, params: { id: candidate.id }
      end

      it 'renders template' do
        expect(response).to render_template :show
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :developer, :active) }
      before do
        login_user(candidate)
        get :show, params: { id: candidate.id }
      end

      it 'renders template' do
        expect(response).to render_template :show
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET #edit' do
    let!(:candidate) { create(:user, :developer, :active) }

    context 'not authorized' do
      before do
        login_user(candidate)
        get :edit, params: { id: candidate.id }
      end

      it 'redirect to dashboard root' do
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'authorized staff' do
      before do
        login_user(user)
        get :edit, params: { id: candidate.id }
      end

      it 'renders template' do
        expect(response).to render_template :edit
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'PUT #update' do
    let(:skill) { create(:skill) }
    let(:attr) do
      {
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        location: Faker::Address.country,
        timezone: Faker::Address.time_zone,
        cv_url: Faker::Internet.url,
        github: Faker::Internet.user_name,
        primary_skill_id: skill.id
      }
    end
    let!(:candidate) { create(:user, :developer, :active, :with_primary_skill) }

    context 'not authorized' do
      let(:actual) { candidate.primary_skill }
      before { login_user(candidate) }

      it 'redirect to dashboard root' do
        put :update, params: { id: candidate.id, user: attr }
        expect(response).to redirect_to dashboard_root_url
      end

      it 'user not updated' do
        put :update, params: { id: candidate.id, user: attr }
        candidate.reload
        expect(candidate.primary_skill).to eq actual
      end
    end

    context 'authorized staff' do
      before { login_user(user) }

      context 'validates params' do
        it 'redirect to user' do
          put :update, params: { id: candidate.id, user: attr }
          expect(response).to redirect_to dashboard_user_url(candidate)
        end

        it 'user updated' do
          put :update, params: { id: candidate.id, user: attr }
          candidate.reload
          expect(candidate.primary_skill).to eq skill
        end
      end

      context 'not validates params' do
        let!(:invalid_attr) do
          {
            first_name: nil
          }
        end

        it 'render edit' do
          put :update, params: { id: candidate.id, user: invalid_attr }
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'PUT #active' do
    context 'authorized' do
      let!(:candidate) { create(:user, :developer, :disabled) }
      before { login_user(user) }

      it 'calls Activate operation' do
        expect(Ops::Developer::Activate).to receive(:call).with(user: candidate, performer: user.id)
        put :activate, params: { id: candidate.id }
      end

      it 'redirects to users list' do
        put :activate, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_users_url
      end

      it 'assigns success flash' do
        put :activate, params: { id: candidate.id }
        expect(flash[:success]).to be_present
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :developer, :active) }
      before { login_user(candidate) }

      it 'redirects to dashboard root' do
        put :activate, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_root_url
      end
    end
  end

  describe 'PUT #deactivate' do
    context 'authorized' do
      let(:candidate) { create(:user, :developer, :active) }
      before { login_user(user) }

      it 'calls Activate operation' do
        expect(Ops::Developer::Disable).to receive(:call).with(user: candidate)
        put :deactivate, params: { id: candidate.id }
      end

      it 'redirect to users list' do
        put :deactivate, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_users_url
      end
    end

    context 'not authorized' do
      let(:user) { create(:user, :developer, :active) }
      let(:candidate) { create(:user, :developer, :active) }
      before { login_user(user) }

      it 'redirect to dashboard root' do
        put :deactivate, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_root_url
      end

      it 'flash access deny disabled user' do
        put :deactivate, params: { id: candidate.id }
        expect(flash[:danger]).to eq(I18n.t('dashboard.users.access.deny'))
      end
    end
  end

  describe 'PUT #add_role' do
    let(:role) { 'staff' }

    context 'authorized' do
      let!(:candidate) { create(:user, :developer, :active) }
      before { login_user(user) }

      it 'calls Activate operation' do
        expect(Ops::Developer::AssignRole).to receive(:call).with(user: candidate, role: role)
        put :add_role, params: { id: candidate.id, role: role }
      end

      it 'redirect to user' do
        put :add_role, params: { id: candidate.id, role: role }
        expect(response).to redirect_to dashboard_user_url(candidate)
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :developer, :active) }
      before { login_user(candidate) }

      it 'redirect to dashboard root' do
        put :add_role, params: { id: candidate.id, role: role }
        expect(response).to redirect_to dashboard_root_url
      end
    end
  end

  describe 'PUT #remove_role' do
    let(:role) { 'staff' }

    context 'authorized' do
      let!(:candidate) { create(:user, :developer, :active, :staff) }
      before { login_user(user) }

      it 'calls Activate operation' do
        expect(Ops::Developer::RemoveRole).to receive(:call).with(user: candidate,
                                                                  role: role,
                                                                  size: candidate.roles.size)
        put :remove_role, params: { id: candidate.id, role: role, size: candidate.roles.size }
      end

      it 'redirect to user' do
        put :remove_role, params: { id: candidate.id, role: role, size: candidate.roles.size }
        expect(response).to redirect_to dashboard_user_url(candidate)
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :developer, :active) }
      before { login_user(candidate) }

      it 'redirect to dashboard root' do
        put :remove_role, params: { id: candidate.id, role: role }
        expect(response).to redirect_to dashboard_root_url
      end
    end

    context 'removing last role users' do
      let!(:candidate) { create(:user, :developer, :active) }
      let!(:role) { 'developer' }
      before { login_user(user) }

      it 'redirect to user' do
        put :remove_role, params: { id: candidate.id, role: role }
        expect(response).to redirect_to dashboard_user_url(candidate)
      end

      it 'flash error remove last role' do
        put :remove_role, params: { id: candidate.id, role: role }
        expect(flash[:danger]).to eq(I18n.t('dashboard.users.alert.last_role'))
      end
    end
  end
end
