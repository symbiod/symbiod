# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::Screening::Start do
  describe '#call' do
    subject { described_class }
    let(:user) { create(:user, :member) }
    let(:positions) { Ops::Member::Screening::Start::NUMBER_OF_ASSIGNED_TEST_TASKS }
    let(:params) { { user: user, positions: positions } }

    it 'start test task assignments' do
      expect(Ops::Member::AssignTestTasks).to receive(:call).with(user: user, positions: positions)
      subject.call(params)
    end
  end
end
