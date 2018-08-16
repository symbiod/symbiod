# frozen_string_literal: true

require 'rails_helper'

describe Ops::Roles::Activate do
  subject { described_class }

  describe '#call' do
    let(:role) { create(:role, :developer, :disabled) }
    let(:params) { { role: role } }

    it 'changes role state' do
      expect { subject.call(params) }
        .to change { role.reload.state }
        .from('disabled').to('active')
    end
  end
end
