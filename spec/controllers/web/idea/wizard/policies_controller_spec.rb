require 'rails_helper'

RSpec.describe Web::Idea::Wizard::PoliciesController do
  subject { response }
  let(:user) { create(:user, :author, :pending) }

  before { login_user(user) }

  describe 'GET #edit' do
    context 'when the user is pending author' do
      before { get :edit }

      it { is_expected.to render_template :edit }
      it { is_expected.to be_successful }
    end

    context 'when the user has different state' do
      let(:user) { create(:user, :author, :policy_accepted) }
      let(:invoke_action) { get :edit }

      it_behaves_like 'checks step permissions for author'
    end
  end

  describe 'PUT #update' do
    let(:result) { double(success?: policy_accepted?) }

    before do
      expect(Ops::Author::AcceptPolicy)
        .to receive(:call)
        .with(any_args)
        .and_return(result)
        .at_least(:once)
      put :update, params: { user: { accept_policy: '1' } }
    end

    context 'when the policy is accepted' do
      let(:policy_accepted?) { true }

      it 'redirects to the next step' do
        put :update, params: { user: { accept_policy: '1' } }

        path_helper = Author::Wizard.new(user).route_for_current_step
        is_expected.to redirect_to public_send(path_helper)
      end
    end

    context 'when the policy is not accepted' do
      let(:policy_accepted?) { false }

      it 'renders form' do
        is_expected.to render_template :edit
      end
    end
  end
end
