# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::UpdateProfile do
  subject { described_class }

  describe '.call' do
    let(:user) { create(:user, :active, :with_primary_skill) }
    let(:user_skill) { user.primary_skill }
    let(:skill) { create(:skill) }
    let(:skill_params) { { primary_skill_id: skill.id } }

    context 'valid profile data provided' do
      let(:profile_params) { valid_user_attributes.merge(github: 'username') }
      let(:params) { profile_params.merge(skill_params) }

      it 'updates profile' do
        expect { subject.call(user: user, params: params) }
          .to change(user.reload, :first_name)
          .to(params[:first_name])
      end

      it 'update primary user skill' do
        expect { subject.call(user: user, params: params) }
          .to change { user.reload.primary_skill }
          .from(user_skill)
          .to(skill)
      end
    end

    context 'invalid provided data' do
      let(:invalid_profile_params) do
        {
          first_name: nil
        }
      end
      let(:params) { invalid_profile_params.merge(skill_params) }

      it 'does not update profile' do
        expect { subject.call(user: user, params: params) } # rubocop:disable Lint/AmbiguousBlockAssociation
          .not_to change { user.reload.first_name }
      end

      it 'does not create primary skill for user' do
        expect { subject.call(user: user, params: params) }
          .not_to change(user.reload, :primary_skill)
      end
    end
  end
end
