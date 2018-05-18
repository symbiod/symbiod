# frozen_string_literal: true

require 'rails_helper'

describe Web::Bootcamp::HomeController do
  describe 'GET #index' do
    context 'authenticated' do
      let(:user) { create(:user) }
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

    context 'not authenticated' do
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
