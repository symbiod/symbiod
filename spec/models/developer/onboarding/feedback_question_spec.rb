# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::Onboarding::FeedbackQuestion, type: :model do
  subject(:question) { create(:feedback_question) }

  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of(:key_name) }
  it { is_expected.to validate_uniqueness_of(:key_name).ignoring_case_sensitivity }
end
