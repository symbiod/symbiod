require 'rails_helper'

RSpec.describe Web::LocalesController do
  describe 'GET #toggle' do
    before { request.session[:locale] = current_locale }

    context 'when english locale is enabled' do
      let(:current_locale) { :en }

      it 'changes locale to russian' do
        get :toggle
        expect(session[:locale]).to eq :ru
      end
    end

    context 'when russian locale is enabled' do
      let(:current_locale) { :ru }

      it 'changes locale to english' do
        get :toggle
        expect(session[:locale]).to eq :en
      end
    end
  end
end
