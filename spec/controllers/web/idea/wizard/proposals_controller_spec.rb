# frozen_string_literal: true

require 'rails_helper'

describe Web::Idea::Wizard::ProposalsController do
  let!(:user) { create(:user, :author, :pending) }

  describe 'GET #index' do
    context 'authenticated' do
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

    context 'non-authenticated' do
      it 'redirects to root idea landing' do
        get :index
        expect(response).to redirect_to public_send(Author::Wizard.new(nil).route_for_current_step)
      end
    end
  end

  describe 'POST #create' do
    context 'authenticated' do
      before { login_user(user) }

      context 'valid params' do
        let(:result_double) { double(success?: true) }
        let(:idea_params) { { name: 'title', description: 'description' } }

        it 'calls operation' do
          expect(Ops::Idea::Submit)
            .to receive(:call)
            .with(any_args)
            .and_return(result_double)
          post :create, params: { idea: idea_params }
        end

        it 'redirects to proposals' do
          post :create, params: { idea: idea_params }
          expect(response).to redirect_to idea_wizard_proposals_url
        end
      end

      context 'invalid params' do
        let(:idea_params) { { name: nil } }

        it 'renders form' do
          post :create, params: { idea: idea_params }
          expect(response).to render_template :index
        end
      end
    end

    context 'non-authenticated' do
      let(:idea_params) { { name: 'title', description: 'description' } }

      it 'redirects to root idea landing' do
        post :create, params: { idea: idea_params }
        expect(response).to redirect_to public_send(Author::Wizard.new(nil).route_for_current_step)
      end
    end
  end
end
