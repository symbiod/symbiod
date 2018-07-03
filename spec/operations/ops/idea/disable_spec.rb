# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::Disable do
  subject { described_class }

  describe '#call' do
    let(:idea) { create(:idea, :active) }
    let(:params) { { idea: idea } }

    it 'changes idea state' do
      expect { subject.call(params) }
        .to change(idea.reload, :state)
        .from('active').to('disabled')
    end
  end
end
