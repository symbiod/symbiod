# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Dashboard::ProfilesController do
  let(:user) { create(:user, :developer, :active) }

  describe 'GET #show' do
    context 'authenticated' do
      before do
        login_user(user)
        get :show
      end

      it 'renders template' do
        expect(response).to render_template :show
      end

      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'assigns profile' do
        expect(assigns(:profile)).to eq user
      end
    end
  end

  describe 'GET #edit' do
    context 'authenticated' do
      before do
        login_user(user)
        get :edit
      end

      it 'renders template' do
        expect(response).to render_template :edit
      end

      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'assigns profile' do
        expect(assigns(:profile)).to eq user
      end
    end
  end

  describe 'PUT #update' do
    context 'authenticated' do
      before { login_user(user) }

      context 'valid params' do
        let(:params) do
          {
            first_name: 'Some new name',
            last_name:  'Some new last_name',
            location:   'Some new location'
          }
        end

        it 'updates user fields' do
          expect { put :update, params: { user: params } }
            .to change(user.reload, :first_name).to(params[:first_name])
            .and change(user.reload, :last_name).to(params[:last_name]) # rubocop:disable Layout/MultilineMethodCallIndentation,Metrics/LineLength
            .and change(user.reload, :location).to(params[:location]) # rubocop:disable Layout/MultilineMethodCallIndentation,Metrics/LineLength
        end

        it 'redirects to profile' do
          put :update, params: { user: params }
          expect(response).to redirect_to dashboard_profile_url
        end
      end

      context 'invalid params' do
        let(:params) do
          {
            first_name: '',
            last_name:  'Some new last_name',
            location:   'Some new location'
          }
        end

        it 'renders form' do
          put :update, params: { user: params }
          expect(response).to render_template :edit
        end

        it 'does not change fields' do
          expect { put :update, params: { user: params } }
            .not_to(change { user.reload.first_name })
        end
      end

      context 'non-whitelisted params exist' do
        let(:params) do
          {
            last_name:  'Some new last_name',
            email: 'some-new-email@gmail.com'
          }
        end

        it 'changes whitelisted fields' do
          expect { put :update, params: { user: params } }
            .to(change { user.reload.last_name })
        end

        it 'does not change non-whitelisted fields' do
          expect { put :update, params: { user: params } }
            .not_to(change { user.reload.email })
        end
      end
    end
  end
end
