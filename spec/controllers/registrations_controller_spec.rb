require 'rails_helper'

RSpec.describe Web::Bootcamp::RegistrationsController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      subject { post 'create', params: { bootcamp_registration: attributes_for(:user, :with_name) } }

      it 'saves the new user to database' do
        expect { subject }.to change(User.all, :count).by(1)
      end

      it 'redirects to root' do
        expect(subject).to redirect_to(root_url(subdomain: 'www'))
      end
    end

    context 'with invalid attributes (without name)' do
      subject { post 'create', params: { bootcamp_registration: attributes_for(:user) } }

      it 'not saves the new user to database' do
        expect { subject }.to change(User.all, :count).by(0)
      end

      it 'redirects to root' do
        expect(subject).to render_template(:new)
      end
    end
  end
end
