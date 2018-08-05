# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::HomeController do
  describe 'GET #index' do
    context 'not authenticated' do
      it 'redirects to root landing page' do
        get :index
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'pending user' do
      let(:user) { create(:user, :developer) }
      before { login_user(user) }

      it 'redirects to root landing page' do
        get :index
      end
    end

    context 'active user' do
      let(:user) { create(:user, :developer, :active) }
      before { login_user(user) }

      it 'renders template' do
        get :index
        expect(response).to render_template :index
      end

      it 'returns success status' do
        get :index
        expect(response.status).to eq 200
      end
    end

    context 'staff' do
      let(:user) { create(:user, :developer, :staff) }
      before { login_user(user) }

      it 'renders template' do
        get :index
        expect(response).to render_template :index
      end

      it 'returns success status' do
        get :index
        expect(response.status).to eq 200
      end
    end
  end
end
