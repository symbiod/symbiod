# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::Vote do
  subject { described_class }

  describe '#call' do
    let(:idea) { create(:idea, :voting) }
    let(:user) { create(:user, :developer, :active) }
    let(:params) { { idea: idea, user: user, vote_type: %w[up down].sample } }

    it 'create vote idea' do
      expect { subject.call(params) }
        .to change(Vote, :count).by(1)
    end
  end
end
