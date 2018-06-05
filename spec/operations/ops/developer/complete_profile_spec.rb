# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::CompleteProfile do
  subject { described_class }

  describe '.call' do
    let(:user) { create(:user, :policy_accepted) }

    context 'valid profile data provided' do
      let(:params) { valid_user_attributes }

      it 'updates profile' do
        expect { subject.call(user: user, params: params) }
          .to change(user.reload, :first_name)
          .to(params[:first_name])
      end

      it 'changes user state' do
        expect { subject.call(user: user, params: params) }
          .to change(user.reload, :state)
          .to('profile_completed')
      end

      it 'calls StartScreening operation' do
        expect(Ops::Developer::Screening::Start)
          .to receive(:call)
          .with(user: user)
        subject.call(user: user, params: params)
      end
    end

    context 'invalid provided data' do
      let(:params) do
        {
          first_name: nil
        }
      end

      it 'does not update profile' do
        expect { subject.call(user: user, params: params) } # rubocop:disable Lint/AmbiguousBlockAssociation
          .not_to change { user.reload.first_name }
      end

      it 'does not change user state' do
        expect { subject.call(user: user, params: params) }
          .not_to change(user.reload, :state)
      end

      it 'does not call StartScreening operation' do
        expect(Ops::Developer::Screening::Start)
          .not_to receive(:call)
          .with(user: user)
        subject.call(user: user, params: params)
      end
    end
  end
end
