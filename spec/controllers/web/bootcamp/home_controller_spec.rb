# frozen_string_literal: true

require 'rails_helper'

describe Web::Bootcamp::HomeController do
  describe 'GET #index' do
    context 'authenticated' do
      before { login_user(user) }

      context 'pending user' do
        let(:user) { create(:user, :pending) }

        it 'redirects to screenings path' do
          get :index
          expect(response).to redirect_to bootcamp_wizard_screenings_url
        end
      end

      context 'user completed screening' do
        let(:user) { create(:user, :screening_completed) }

        it 'redirects to screenings path' do
          get :index
          expect(response).to redirect_to bootcamp_wizard_screenings_url
        end
      end

      context 'user active' do
        let(:user) { create(:user, :active) }

        it 'redirect to dashboard root path' do
          get :index
          expect(response).to redirect_to dashboard_root_url
        end
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
