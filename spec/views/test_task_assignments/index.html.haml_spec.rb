# frozen_string_literal: true

require 'rails_helper'

describe 'web/dashboard/test_task_assignments/index' do
  let!(:candidates) do
    create_list(:user, 2, :with_primary_skill_java)
  end

  before do
    @candidates = candidates
  end

  describe 'index view' do
    it 'renders without error' do
      expect { render }.not_to raise_error
    end

    it 'renders contain' do
      render

      expect(rendered).to match(candidates.first.email)
      expect(rendered).to match(/Java/)
    end
  end
end
