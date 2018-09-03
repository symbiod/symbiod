# frozen_string_literal: true

require 'rails_helper'

describe 'web/dashboard/test_task_assignments/show' do
  before do
    assign(:candidate, create(:user,
                              :member,
                              :with_assignment_completed,
                              :active,
                              :with_primary_skill_java,
                              first_name: 'Bob',
                              last_name: 'Marley'))
  end

  it 'renders without error' do
    expect { render }.not_to raise_error
  end

  it 'renders contain' do
    render

    expect(rendered).to match(/Bob Marley/)
    expect(rendered).to match(/Java/)
  end
end
