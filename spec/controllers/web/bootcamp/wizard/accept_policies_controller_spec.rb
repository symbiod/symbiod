# frozen_string_literal: true

require 'rails_helper'

describe Web::Bootcamp::Wizard::AcceptPoliciesController do
  describe 'PUT #update' do
    context 'policy accepted' do
      let(:user) { create(:user, :developer, :profile_completed) }
      let(:result) { double(success?: true) }
      before { login_user(user) }

      it 'calls operation' do
        expect(Ops::Developer::AcceptPolicy)
          .to receive(:call)
          .with(any_args)
          .and_return(result)
        put :update, params: { user: { accept_policy: '1' } }
      end

      it 'redirect to profile edit' do
        put :update, params: { user: { accept_policy: '1' } }
        expect(response).to redirect_to bootcamp_wizard_screenings_url
      end
    end

    context 'policy not accepted' do
      let(:user) { create(:user, :developer, :profile_completed) }
      before { login_user(user) }

      it 'render edit' do
        put :update, params: { user: { accept_policy: '0' } }
        expect(response).to render_template :edit
      end
    end
  end
end
