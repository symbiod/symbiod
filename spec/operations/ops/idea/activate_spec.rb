# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::Activate do
  subject { described_class }

  describe '#call' do
    before do
      create(:stack, :rails_monolith)
      create(:user, :mentor, :active)
    end

    let(:idea) { create(:idea, :voting) }
    let(:params) { { idea: idea } }

    it 'changes idea state' do
      expect { subject.call(params) }
        .to change(idea.reload, :state)
        .from('voting').to('active')
    end

    it 'starting create project' do
      expect(Ops::Projects::Kickoff).to receive(:call).with(idea: idea)
      subject.call(params)
    end
  end
end
