# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member::Onboarding::SurveyResponse, type: :model do
  subject { described_class.new }
  before { create(:feedback_question, key_name: 'question_1') }

  it { is_expected.to serialize(:feedback).as(SurveyResponseSerializer) }

  it { is_expected.to belong_to :role }
  it { is_expected.to have_one :newcomer }

  its(:feedback) { is_expected.to eq({}) }
  its(:question_1) { is_expected.to eq nil }
end
