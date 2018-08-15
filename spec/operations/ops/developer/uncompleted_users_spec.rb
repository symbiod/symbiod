# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::UncompletedUsers do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user) }
    let(:params) { { user: user } }

    it 'sends invitation to Github' do
      expect(::Developer::SendFollowupJob)
        .to receive(:perform_later)
        .with(user.id)
      subject.call(params)
    end
  end
end
