# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::TestTaskStatusButton do
  subject do
    described_class.new(test_task, context: { controller: controller }).link_to_status(confirm: test_task.state)
  end

  controller Web::Dashboard::TestTasksController

  context 'test task status active' do
    let(:test_task) { create(:member_test_task) }

    it_behaves_like 'button status is active'
  end

  context 'test task status disabled' do
    let(:test_task) { create(:member_test_task, :disabled) }

    it_behaves_like 'button status is disabled'
  end
end
