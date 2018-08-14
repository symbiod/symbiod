# frozen_string_literal: true

require 'rails_helper'

describe Projects::GenerateGithubTeamJob do
  describe '#perform' do
    let(:project) { create(:project) }

    it 'calls Projects::Kickoff operation' do
      expect(Ops::Projects::GenerateProjectGithubTeam).to receive(:call).with(project: project)
      described_class.perform_now(project.id)
    end
  end
end
