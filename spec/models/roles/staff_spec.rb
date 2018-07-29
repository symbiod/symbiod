# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Roles::Staff do
  subject(:role) { build_stubbed(:role, :staff) }

  describe 'role default state' do
    it 'is active' do
      expect(role).to have_state(:active)
    end
  end

  describe 'changes in role states' do
    it 'activate role' do
      expect(role)
        .to transition_from(:disabled).to(:active)
                                      .on_event(:activate)
    end

    it 'disable role' do
      expect(role)
        .to transition_from(:active).to(:disabled)
                                    .on_event(:disable)
    end
  end
end
