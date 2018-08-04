# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::NotesController, type: :controller do
  let(:user) { create(:user, :active, :developer) }

  describe 'GET #new' do
    context 'not signed in' do
      before { get :new, params: { user_id: user.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before do
        login_user(current_user)
        get :new, params: { user_id: user.id }
      end

      context 'current user has role staff or mentor' do
        let(:current_user) { create(:user, :active, :staff_or_mentor) }

        it 'renders template' do
          expect(response).to render_template :new
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end
      end

      context 'current user has role developer or author' do
        let(:current_user) { create(:user, :active, :developer_or_author) }

        it 'redirects to user page' do
          expect(response).to redirect_to dashboard_user_url(user)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'not signed in' do
      before { post :create, params: { user_id: user.id, note: params_note } }

      let(:params_note) { { content: 'Content' } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(current_user) }

      context 'valid params note' do
        let(:params_note) { { content: 'Contents' } }

        context 'current user has role staff or mentor' do
          let(:current_user) { create(:user, :active, :staff_or_mentor) }

          it 'created note' do
            expect { post :create, params: { user_id: user.id, note: params_note } }
              .to change(Note, :count).by(1)
          end

          it 'redirects to user page' do
            post :create, params: { user_id: user.id, note: params_note }
            expect(response).to redirect_to dashboard_user_url(user)
          end
        end

        context 'current user has role developer or author' do
          let(:current_user) { create(:user, :active, :developer_or_author) }

          it 'not created note' do
            expect { post :create, params: { user_id: user.id, note: params_note } }
              .to change(Note, :count).by(0)
          end

          it 'redirects to user page' do
            post :create, params: { user_id: user.id, note: params_note }
            expect(response).to redirect_to dashboard_user_url(user)
          end
        end
      end

      context 'invalid params note' do
        let(:invalid_params_note) { { content: '' } }

        context 'user has role staff or mentor' do
          let(:current_user) { create(:user, :active, :staff_or_mentor) }

          it 'not created note' do
            expect { post :create, params: { user_id: user.id, note: invalid_params_note } }
              .to change(Note, :count).by(0)
          end

          it 'renders template' do
            post :create, params: { user_id: user.id, note: invalid_params_note }
            expect(response).to render_template :new
          end
        end
      end
    end
  end
end
