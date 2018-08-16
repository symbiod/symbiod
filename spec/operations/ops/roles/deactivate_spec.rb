# frozen_string_literal: true

require 'rails_helper'

describe Ops::Roles::Deactivate do
  subject { described_class }

  describe '#call' do
    let(:role) { create(:role, :developer, :active) }
    let(:params) { { role: role } }

    it 'changes role state' do
      expect { subject.call(params) }
        .to change { role.reload.state }
        .from('active').to('disabled')
    end
  end
end
