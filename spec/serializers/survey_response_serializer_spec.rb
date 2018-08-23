# frozen_string_literal: true

require 'rails_helper'

describe SurveyResponseSerializer do
  subject { described_class }

  describe '#dump' do
    let(:hash) { { question_1: 'Answer 1', question_2: 'Answer 2' } }

    it 'return JSON' do
      expect(subject.dump(hash)).to eq '{"question_1":"Answer 1","question_2":"Answer 2"}'
    end
  end

  describe '#load' do
    context 'json is string' do
      let(:hash) { '{"question_1":"Answer 1","question_2":"Answer 2"}' }

      it 'return hash' do
        expect(subject.load(hash)).to eq('question_1' => 'Answer 1', 'question_2' => 'Answer 2')
      end
    end

    context 'json is hash' do
      let(:hash) { { 'question_1': 'Answer 1', 'question_2': 'Answer 2' } }

      it 'return hash' do
        expect(subject.load(hash)).to eq('question_1' => 'Answer 1', 'question_2' => 'Answer 2')
      end
    end
  end
end
