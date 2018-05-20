# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::OnboardingProgress do
  subject { described_class }
  let(:user) { create(:user) }
  let(:params) { { user: user } }

  describe '#call' do
    context 'user does not have completed tasks' do
      before { create(:developer_test_task_assignment, :uncompleted, developer: user) }

      it 'progress 0%' do
        expect(subject.new(user).percent).to eq 0
      end
    end

    context 'user have all completed tasks' do
      before do
        create(:developer_test_task_assignment, :completed, developer: user)
        create(:developer_onboarding, :slack_invited, :github_invited, user: user)
      end

      it 'progress 100%' do
        expect(subject.new(user).percent).to eq 100
      end
    end
  end
end
