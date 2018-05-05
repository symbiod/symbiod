# frozen_string_literal: true

require 'rails_helper'

describe Web::Idea::HomeController do
  describe '#index' do
    it 'renders landing' do
      get :index
      expect(response).to render_template :index
    end

    it 'returns success status' do
      get :index
      expect(response.status).to eq 200
    end
  end
end
