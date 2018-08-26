# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::Downvote do
  subject { described_class }

  describe '#call' do
    let(:idea) { create(:idea, :voting) }
    let(:user) { create(:user, :member, :active) }
    let(:params) { { idea: idea, user: user } }

    it 'created vote idea' do
      expect { subject.call(params) }
        .to change(Vote, :count).by(1)
    end
  end
end
