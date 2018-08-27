# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::Onboarding::Progress do
  subject { described_class.new(user).percent }
  let(:user) { create(:user) }
  let(:params) { { user: user } }

  describe '#call' do
    context 'user does not have completed tasks' do
      before { create(:member_test_task_assignment, :uncompleted, member: user) }

      it 'progress 0%' do
        is_expected.to eq 0
      end
    end

    context 'user have all completed tasks' do
      before do
        create(:member_test_task_assignment, :completed, member: user)
        create(:member_onboarding, :joined_to_slack, :joined_to_github, :feedback_completed, user: user)
      end

      it 'progress 100%' do
        is_expected.to eq 100
      end
    end
  end
end
