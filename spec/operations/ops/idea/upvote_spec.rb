# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::Upvote do
  subject { described_class }

  describe '#call' do
    before { create(:stack, :rails_monolith) }

    let(:idea) { create(:idea, :voting) }
    let(:user) { create(:user, :developer, :active) }
    let(:params) { { idea: idea, user: user } }

    context 'idea has no votes' do
      let(:result) { { url: 'idea', model: idea, flash: 'success' } }

      it 'created vote idea' do
        expect { subject.call(params) }
          .to change(Vote, :count).by(1)
      end

      it 'not created idea project' do
        expect { subject.call(params) }
          .to change(Project, :count).by(0)
      end

      it 'return result idea' do
        expect(subject.call(params)['redirect_to']).to eq result
      end
    end

    context 'idea has 4 votes' do
      before { create_list(:vote, 4, idea: idea) }
      let(:result) { { url: 'project', model: idea.project, flash: 'success_project' } }

      it 'created vote idea' do
        expect { subject.call(params) }
          .to change(Vote, :count).by(1)
      end

      it 'created idea project' do
        expect { subject.call(params) }
          .to change(Project, :count).by(1)
      end

      it 'return result idea' do
        expect(subject.call(params)['redirect_to']).to eq result
      end
    end
  end
end
