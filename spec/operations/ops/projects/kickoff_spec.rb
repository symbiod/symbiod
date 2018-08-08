# frozen_string_literal: true

require 'rails_helper'

describe Ops::Projects::Kickoff do
  subject { described_class }
  let!(:service) { double }

  describe '#call' do
    before do
      create(:stack, :rails_monolith)
      create_list(:vote, 2, idea: idea)
      create_list(:vote, 3, :down, idea: idea)
    end

    let(:idea) { create(:idea, :voting) }
    let(:params) { { idea: idea } }

    it 'create project' do
      expect { subject.call(params) }
        .to change(Project, :count).by(1)
    end

    it 'add users to project' do
      subject.call(params)
      expect(idea.project.users.count).to eq 2
    end

    it 'run job to create slack channel' do
      expect(::Projects::CreateSlackChannelJob)
        .to receive(:perform_later)
      subject.call(params)
    end
  end
end
