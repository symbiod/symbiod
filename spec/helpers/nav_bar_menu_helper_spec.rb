# frozen_string_literal: true

require 'rails_helper'

describe NavBarMenuHelper do
  describe '#count_applicants' do
    context 'pending applications exist' do
      let!(:candidate1) { create(:user, :member, :screening_completed) }
      let!(:candidate2) { create(:user, :member, :screening_completed) }
      let!(:candidate3) { create(:user, :member, :active) }

      it 'returns positive number of pending users' do
        expect(count_applicants).to eq '(2)'
      end
    end

    context 'no pending applications' do
      it 'returns nil' do
        expect(count_applicants).to eq nil
      end
    end
  end

  describe '#nav_item_link' do
    context 'user denied access to page' do
      let(:current_user) { create(:user, :member, :active) }
      let(:policy_name) { :test_task_assignment }

      it 'returns nil' do
        expect(nav_item_link('name link', 'url', policy_name: policy_name)).to eq nil
      end
    end

    context 'user allow acces to page' do
      let(:current_user) { create(:user, :staff, :active) }
      let(:policy_name) { :test_task_assignment }
      let(:nav) do
        '<li class="nav-item"><a class="nav-link" href="url"><span data-feather="list"></span>name link</a></li>'
      end

      it 'renders link' do
        expect(nav_item_link('name link', 'url', policy_name: policy_name))
          .to eq nav
      end
    end
  end
end
