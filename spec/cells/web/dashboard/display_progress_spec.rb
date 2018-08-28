# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::DisplayProgress do
  subject { described_class.new(user) }

  context 'progress more then 0%' do
    let(:user) { create(:user, :member, :active) }
    before { create(:member_test_task_assignment, :completed, member: user) }

    it 'renders success color' do
      expect(subject.progress_bar).to match('class="progress-bar bg-success"')
    end
  end

  context 'progress equal 0%' do
    let(:user) { create(:user) }
    before { create(:member_test_task_assignment, :uncompleted, member: user) }

    it 'renders danger color' do
      expect(subject.progress_bar).to match('class="progress-bar bg-danger"')
    end
  end
end
