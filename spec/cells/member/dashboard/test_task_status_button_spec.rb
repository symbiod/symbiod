# frozen_string_literal: true

require 'rails_helper'

describe Member::Dashboard::TestTaskStatusButton do
  subject { described_class.new(member_test_task, context: { controller: controller }).test_task_status }

  controller Web::Dashboard::TestTasksController

  context 'test task status active' do
    let(:member_test_task) { create(:member_test_task) }

    it 'renders active status' do
      expect(subject).to match(/active/)
    end

    it 'renders success color link' do
      expect(subject).to match(/<a class="btn btn-success btn-sm"/)
    end

    it 'renders link to disable' do
      expect(subject).to match(/deactivate/)
    end

    it 'renders link to confirm status to disable' do
      expect(subject).to match(/data-confirm="Are you sure to disable/)
    end
  end

  context 'test task status disabled' do
    let(:member_test_task) { create(:member_test_task, :disabled) }

    it 'renders active status' do
      expect(subject).to match(/disabled/)
    end

    it 'renders success color link' do
      expect(subject).to match(/<a class="btn btn-danger btn-sm"/)
    end

    it 'renders link to disable' do
      expect(subject).to match(/activate/)
    end

    it 'renders link to confirm status to disable' do
      expect(subject).to match(/data-confirm="Are you sure to activate/)
    end
  end
end
