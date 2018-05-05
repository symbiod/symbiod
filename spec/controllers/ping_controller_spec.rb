require 'rails_helper'

describe PingController do
  describe '#index' do
    subject { response }
    before { get :index }

    its(:status) { is_expected.to eq 200 }
  end
end
