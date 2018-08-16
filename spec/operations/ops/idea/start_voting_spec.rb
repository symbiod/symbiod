# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::StartVoting do
  subject { described_class }

  describe '#call' do
    let(:author) { create(:role, :author, author_state) }
    let(:author_state) { :policy_accepted }
    let(:idea) { create(:idea, :pending, author: author.user) }
    let(:params) { { idea: idea } }

    it 'changes idea state' do
      expect { subject.call(params) }
        .to change(idea.reload, :state)
        .from('pending').to('voting')
    end

    describe '#activates author' do
      context 'author is new' do
        let(:author_state) { :policy_accepted }

        it 'activates author' do
          expect { subject.call(params) }
            .to change { author.reload.state }
            .from('policy_accepted')
            .to('active')
        end
      end

      context 'author is already activated' do
        let(:author_state) { :active }

        it 'does not activate author' do
          expect { subject.call(params) }
            .not_to change { author.reload.state }
            .from('active')
        end
      end
    end
  end
end
