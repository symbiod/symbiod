require 'rails_helper'

RSpec.describe Web::SignOutsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before do
      login_user(user)
      delete :destroy, params: { id: user.id }
    end

    it 'session is destroyed' do
      expect(logged_in?).to eq false
    end

    it 'redirects to main page' do
      is_expected.to redirect_to(root_landing_url)
    end
  end
end
