# frozen_string_literal: true

require 'rails_helper'

describe Web::Bootcamp::Wizard::ProfilesController do
  let!(:user) { create(:user, :developer, :pending) }

  describe 'GET #edit' do
    context 'authenticated' do
      before { login_user(user) }

      it 'renders template' do
        get :edit
        expect(response).to render_template :edit
      end

      it 'returns success status' do
        get :edit
        expect(response.status).to eq 200
      end

      it_behaves_like 'checks step permissions' do
        let(:wrong_state) { :profile_completed }

        def invoke_action
          get :edit
        end
      end
    end

    context 'non-authenticated' do
      it 'redirects to root landing' do
        get :edit
        expect(response).to redirect_to root_landing_url
      end
    end
  end

  describe 'PUT #update' do
    context 'authenticated' do
      let!(:skill) { create(:skill) }
      before { login_user(user) }

      context 'valid params' do
        let(:result_double) { double(success?: true) }
        let(:user_params) { valid_user_attributes.merge(role: 'mentor', primary_skill_id: skill.id) }

        it 'calls operation' do
          expect(Ops::Developer::CompleteProfile)
            .to receive(:call)
            .with(any_args)
            .and_return(result_double)
          put :update, params: { developer_wizard_profile: user_params }
        end

        it 'redirects to next step' do
          put :update, params: { developer_wizard_profile: user_params }
          expect(response).to redirect_to public_send(Developer::Wizard.new(user).route_for_current_step)
        end

        it_behaves_like 'checks step permissions' do
          let(:wrong_state) { :profile_completed }

          def invoke_action
            put :update, params: { developer_wizard_profile: user_params }
          end
        end
      end

      context 'invalid params' do
        let(:user_params) { { first_name: nil } }

        it 'renders form' do
          put :update, params: { developer_wizard_profile: user_params }
          expect(response).to render_template :edit
        end
      end
    end

    context 'non-authenticated' do
      let(:user_params) { Hash[] }

      it 'redirects to root landing' do
        put :update, params: { developer_wizard_profile: user_params }
        expect(response).to redirect_to root_landing_url
      end
    end
  end
end
