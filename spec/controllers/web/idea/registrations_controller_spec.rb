# frozen_string_literal: true

require 'rails_helper'

describe Web::Idea::RegistrationsController do
  describe 'GET #new' do
    let(:user) { create(:user, :author) }

    context 'user is not logged in' do
      before { get :new }

      it 'renders registration form' do
        expect(response).to render_template :new
      end

      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'assigns new user' do
        expect(assigns(:registration)).to be_an(User)
      end
    end

    context 'user is logged in' do
      before { login_user(user) }

      it 'redirects to idea root' do
        get :new
        expect(response).to redirect_to idea_root_url
      end
    end
  end

  describe 'POST #create' do
    let(:permitted_params) { ActionController::Parameters.new(params[:user]).permit! }
    let(:result) { double(success?: true) }
    before { allow(permitted_params).to receive(:permitted?).and_return(true) }

    context 'valid params' do
      let(:params) do
        {
          user: {
            email: 'user@givemepoc.org',
            password: 'password',
            first_name: 'John',
            last_name: 'Smith',
            location: 'Russia',
            timezone: 'Europe/Moscow'
          }
        }
      end

      it 'calls SignUp operation' do
        expect(Ops::Author::SignUp)
          .to receive(:call)
          .with(params: permitted_params)
          .and_return(result)
        post :create, params: params
      end

      it 'redirects to idea root' do
        post :create, params: params
        expect(response).to redirect_to idea_root_url
      end

      it 'creates new user' do
        expect { post :create, params: params }
          .to change { User.count }
          .by(1)
      end

      it 'assigns author role to new user' do
        post :create, params: params
        expect(User.last.has_role?(:author)).to eq true
      end
    end

    context 'invalid params' do
      let(:params) do
        {
          user: {
            email: 'user@givemepoc.org',
            password: 'password',
            first_name: '',
            last_name: '',
            location: '',
            timezone: ''
          }
        }
      end

      it 'calls SignUp operation' do
        expect(Ops::Author::SignUp)
          .to receive(:call)
          .with(params: permitted_params)
          .and_return(result)
        post :create, params: params
      end

      it 'does not create new user' do
        expect { post :create, params: params }
          .not_to(change { User.count })
      end

      it 'renders sign up form' do
        post :create, params: params
        expect(response).to render_template :new
      end

      it 'returns success status' do
        post :create, params: params
        expect(response).to be_successful
      end
    end
  end
end
