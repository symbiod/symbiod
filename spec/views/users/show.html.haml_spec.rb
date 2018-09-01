# frozen_string_literal: true

require 'rails_helper'

describe 'web/dashboard/users/show' do
  before do
    assign(:user, create(:user, :member, :with_assignment, :active))
    assign(:roles, [create(:role)])
    assign(:test_task_assignments, [create(:member_test_task_assignment)])
  end

  it 'renders without error' do
    expect { render }.not_to raise_error
  end
end
