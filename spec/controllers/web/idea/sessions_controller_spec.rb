# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Idea::SessionsController, type: :controller do
  describe 'GET #new' do
    context 'user is not loged in' do
      it 'assigns new user' do
        get :new
        expect(assigns(:user).class).to eq User
      end
    end

    context 'user is loged in' do
      let(:user) { create(:user, :author) }
      before { login_user(user) }

      it 'assigns new user' do
        get :new
        expect(response).to redirect_to idea_root_url
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'login with correct email and password' do
      before do
        post 'create', params: { idea_login: { email: user.email, password: 'password' } }
      end

      it 'user logged in' do
        expect(logged_in?).to eq true
      end

      it 'redirects to main page' do
        is_expected.to redirect_to(idea_root_url)
      end
    end

    context 'login with incorrect email and password' do
      before do
        post 'create', params: { idea_login: { email: user.email, password: 'secrets' } }
      end

      it 'user not logged in' do
        expect(logged_in?).to eq false
      end

      it 'renders template' do
        is_expected.to render_template(:new)
      end
    end
  end
end
