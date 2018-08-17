# frozen_string_literal: true

require 'rails_helper'

describe Developer::Onboarding::SurveyResponseForm do
  subject { described_class.new(model) }
  let(:model) { Developer::Onboarding::SurveyResponse.new }
  let(:errors) { subject.errors.messages.keys }

  before { subject.validate(params) }

  context 'valid params' do
    let(:params) do
      {
        user_id: 1,
        question_1: 'Answer 1',
        question_2: 'Answer 2'
      }
    end

    it { expect(errors).not_to include :user_id }
    it { expect(errors).not_to include :question_1 }
    it { expect(errors).not_to include :question_2 }

    it { is_expected.to be_valid }
  end

  context 'invalid params' do
    let(:params) { {} }

    it { expect(errors).to include :user_id }
    it { expect(errors).to include :question_1 }
    it { expect(errors).to include :question_2 }

    it { is_expected.not_to be_valid }
  end
end
