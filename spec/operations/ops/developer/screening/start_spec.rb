# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Screening::Start do
  describe '#call' do
    subject { described_class }
    let(:user) { create(:user, :developer) }
    let(:positions) { Ops::Developer::Screening::Start::NUMBER_OF_ASSIGNED_TEST_TASKS }
    let(:params) { { user: user, positions: positions } }

    it 'start test task assignments' do
      expect(Ops::Developer::AssignTestTasks).to receive(:call).with(user: user, positions: positions)
      subject.call(params)
    end
  end
end
