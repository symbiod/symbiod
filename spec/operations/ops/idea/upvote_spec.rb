# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::Upvote do
  subject { described_class }

  describe '#call' do
    before do
      create(:stack, :rails_monolith)
      create(:user, :mentor, :active)
    end

    let(:idea) { create(:idea, :voting) }
    let(:user) { create(:user, :member, :active) }
    let(:params) { { idea: idea, user: user } }

    context 'idea has no votes' do
      let(:result) { nil }

      it 'created vote idea' do
        expect { subject.call(params) }
          .to change(Vote, :count).by(1)
      end

      it 'not created idea project' do
        expect { subject.call(params) }
          .to change(Project, :count).by(0)
      end

      it 'return result idea' do
        expect(subject.call(params)['project']).to eq result
      end
    end

    context 'idea needs one vote for activation' do
      before { create_list(:vote, subject::COUNT_VOTES_KICKOFF_PROJECT - 1, idea: idea) }
      let(:result) { idea.project }

      it 'created vote idea' do
        expect { subject.call(params) }
          .to change(Vote, :count).by(1)
      end

      it 'created idea project' do
        expect { subject.call(params) }
          .to change(Project, :count).by(1)
      end

      it 'return result idea' do
        expect(subject.call(params)['project']).to eq result
      end
    end
  end
end
