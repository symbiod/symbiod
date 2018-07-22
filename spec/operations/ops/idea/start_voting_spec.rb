# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::StartVoting do
  subject { described_class }

  describe '#call' do
    let(:idea) { create(:idea, :pending) }
    let(:params) { { idea: idea } }

    it 'changes idea state' do
      expect { subject.call(params) }
        .to change(idea.reload, :state)
        .from('pending').to('voting')
    end
  end
end
