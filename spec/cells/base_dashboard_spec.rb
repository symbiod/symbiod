# frozen_string_literal: true

require 'rails_helper'

describe BaseDashboard do
  subject { described_class.new(current_user) }
  let!(:current_user) { create(:user, :member, :active) }

  describe '#member_options' do
    let!(:project_1) { create(:project) }
    let!(:project_2) { create(:project) }
    let!(:project_3) { create(:project) }

    it 'returns all projects' do
      expect(subject.send(:member_options)).to eq(projects: [project_1, project_2, project_3])
    end
  end

  describe '#mentor_options' do
    it 'returns blank mentor options' do
      expect(subject.send(:mentor_options)).to eq(mentor_options: '')
    end
  end

  describe '#author_options' do
    it 'returns blank author options' do
      expect(subject.send(:author_options)).to eq(author_options: '')
    end
  end

  describe '#staff_options' do
    it 'returns blank staff options' do
      expect(subject.send(:staff_options)).to eq(staff_options: '')
    end
  end
end
