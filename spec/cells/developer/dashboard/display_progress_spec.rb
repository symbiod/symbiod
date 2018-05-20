# frozen_string_literal: true

require 'rails_helper'

describe Developer::Dashboard::DisplayProgress do
  subject { described_class }

  context 'progress more then 0%' do
    let(:user) { create(:user) }
    before { create(:developer_test_task_assignment, :completed, developer: user) }

    it 'renders success color' do
      expect(subject.new(user).progress_bar).to match('class="progress-bar bg-success"')
    end
  end

  context 'progress equal 0%' do
    let(:user) { create(:user) }
    before { create(:developer_test_task_assignment, :uncompleted, developer: user) }

    it 'renders danger color' do
      expect(subject.new(user).progress_bar).to match('class="progress-bar bg-danger"')
    end
  end
end
