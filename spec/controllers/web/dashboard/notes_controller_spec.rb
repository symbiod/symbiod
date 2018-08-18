# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::NotesController, type: :controller do
  let(:user) { create(:user, :developer, :active) }

  shared_examples 'redirects to landing page' do
    it 'redirects to root landing' do
      expect(response).to redirect_to root_landing_url
    end
  end

  shared_examples 'redirects to user page' do
    it 'redirects to user page' do
      expect(response).to redirect_to dashboard_user_url(user)
    end
  end

  shared_examples 'renders edit' do
    it 'renders template' do
      expect(response).to render_template :edit
    end

    it 'returns success status' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET #new' do
    context 'not signed in' do
      before { get :new, params: { user_id: user.id } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before do
        login_user(current_user)
        get :new, params: { user_id: user.id }
      end

      context 'current user has role staff or mentor' do
        let(:current_user) { create(:user, :staff_or_mentor, :active) }

        it 'renders template' do
          expect(response).to render_template :new
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end
      end

      context 'current user has role developer or author' do
        let(:current_user) { create(:user, :developer_or_author, :active) }

        it_behaves_like 'redirects to user page'
      end
    end
  end

  describe 'POST #create' do
    context 'not signed in' do
      before { post :create, params: { user_id: user.id, note: params_note } }

      let(:params_note) { { content: 'Content' } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before { login_user(current_user) }

      context 'valid params note' do
        let(:params_note) { { content: 'Contents' } }

        context 'current user has role staff or mentor' do
          let(:current_user) { create(:user, :staff_or_mentor, :active) }

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
          let(:current_user) { create(:user, :developer_or_author, :active) }

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
          let(:current_user) { create(:user, :staff_or_mentor, :active) }

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

  describe 'GET #edit' do
    let!(:user) { create(:user, :developer, :active) }

    context 'not signed in' do
      let(:note) { create(:note, noteable: user) }
      before { get :edit, params: { user_id: user.id, id: note.id } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before do
        login_user(current_user)
        get :edit, params: { user_id: user.id, id: note.id }
      end

      context 'current user has role staff or mentor' do
        let!(:current_user) { create(:user, :staff_or_mentor, :active) }

        context 'current user commenter note' do
          let(:note) { create(:note, noteable: user, commenter: current_user) }

          it_behaves_like 'renders edit'
        end

        context 'current user not commenter note' do
          let(:note) { create(:note, noteable: user) }

          it_behaves_like 'redirects to user page'
        end
      end

      context 'current user has role developer or author' do
        let(:current_user) { create(:user, :developer_or_author, :active) }
        let(:note) { create(:note, noteable: user) }

        it_behaves_like 'redirects to user page'
      end
    end
  end

  describe 'PUT #update' do
    let!(:user) { create(:user, :developer, :active) }

    context 'not signed in' do
      let(:params) { { content: 'New content' } }
      let(:note) { create(:note, noteable: user) }
      before { put :update, params: { user_id: user.id, id: note.id, note: params } }

      it_behaves_like 'redirects to landing page'
    end

    context 'sined in' do
      before do
        login_user(current_user)
        put :update, params: { user_id: user.id, id: note.id, note: params }
      end

      context 'valid params' do
        let!(:params) { { content: 'New content' } }

        context 'current user has role staff or mentor' do
          let!(:current_user) { create(:user, :staff_or_mentor, :active) }

          context 'current user commenter note' do
            let(:note) { create(:note, noteable: user, commenter: current_user) }

            it 'success updates note' do
              expect(note.reload.content).to eq 'New content'
            end

            it_behaves_like 'redirects to user page'
          end
        end

        context 'current user has role developer or author' do
          let(:current_user) { create(:user, :developer_or_author, :active) }
          let(:note) { create(:note, noteable: user) }

          it_behaves_like 'redirects to user page'
        end
      end

      context 'invalid params' do
        let!(:params) { { content: '' } }

        context 'current user has staff or mentor' do
          let!(:current_user) { create(:user, :staff_or_mentor, :active) }

          context 'current user commenter note' do
            let(:note) { create(:note, noteable: user, commenter: current_user) }

            it_behaves_like 'renders edit'
          end
        end

        context 'current user has role developer or author' do
          let(:current_user) { create(:user, :developer_or_author, :active) }
          let(:note) { create(:note, noteable: user) }

          it_behaves_like 'redirects to user page'
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user, :developer, :active) }
    let!(:note) { create(:note, noteable: user) }

    shared_examples 'redirects to user page after delete' do
      it 'redirects to user page' do
        delete :destroy, params: { user_id: user.id, id: note.id }
        expect(response).to redirect_to dashboard_user_url(user)
      end
    end

    context 'not signed in' do
      before { delete :destroy, params: { user_id: user.id, id: note.id } }

      it_behaves_like 'redirects to landing page'
    end

    context 'signed in' do
      before { login_user(current_user) }

      context 'current user has role staff or mentor' do
        let(:current_user) { create(:user, :staff_or_mentor, :active) }

        it 'deleted note' do
          expect { delete :destroy, params: { user_id: user.id, id: note.id } }
            .to change(Note, :count).by(-1)
        end

        it_behaves_like 'redirects to user page after delete'
      end

      context 'current user has role developer or author' do
        let(:current_user) { create(:user, :developer_or_author, :active) }

        it 'not deleted note' do
          expect { delete :destroy, params: { user_id: user.id, id: note.id } }
            .to change(Note, :count).by(0)
        end

        it_behaves_like 'redirects to user page after delete'
      end
    end
  end
end
