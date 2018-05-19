# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Bootcamp::UserSessionsController, type: :controller do
  describe 'GET #new' do
    it 'assigns new user' do
      get :new
      expect(assigns(:user).class).to eq User
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'login with correct email and password' do
      before do
        post 'create', params: { bootcamp_login: { email: user.email, password: 'password' } }
      end

      it 'user logged in' do
        expect(logged_in?).to eq true
      end

      it 'redirects to main page' do
        is_expected.to redirect_to(root_landing_url)
      end
    end

    context 'login with incorrect email and password' do
      before do
        post 'create', params: { bootcamp_login: { email: user.email, password: 'secrets' } }
      end

      it 'user not logged in' do
        expect(logged_in?).to eq false
      end

      it 'redirects to main page' do
        is_expected.to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before do
      login_user(user)
      delete 'destroy', params: { id: user.id }
    end

    it 'session is destroyed' do
      expect(logged_in?).to eq false
    end

    it 'redirects to main page' do
      is_expected.to redirect_to(root_landing_url)
    end
  end
end
