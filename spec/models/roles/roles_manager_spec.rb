# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Roles::RolesManager do
  describe 'class methods' do
    subject { described_class }

    describe '.roles' do
      specify { expect(subject.roles).to eq(described_class::MEMBER_ROLES + described_class::OTHER_ROLES) }
    end

    describe '.role_class_name' do
      let(:role_name) { :developer }
      specify { expect(subject.role_class_name(role_name)).to eq 'Roles::Developer' }
    end

    describe '.role_name_by_type' do
      let(:role_class_name) { 'Roles::Developer' }
      specify { expect(subject.role_name_by_type(role_class_name)).to eq 'developer' }
    end

    describe 'instance' do
      subject { described_class.new(user) }
      let(:user) { create(:user, :developer) }

      describe '#add' do
        context 'role is valid' do
          it 'adds role' do
            expect { subject.add(:mentor) }
              .to(change { user.reload.roles.count }.by(1))
          end

          context 'role already exists' do
            it 'does not add role' do
              expect { subject.add(:developer) }
                .not_to(change { user.reload.roles.count })
            end
          end
        end

        context 'role is invalid' do
          it 'does not add role' do
            expect { subject.add(:superuser) }
              .not_to(change { user.reload.roles.count })
          end
        end
      end

      describe '#remove' do
        context 'when roles exists' do
          it 'removes role' do
            expect { subject.remove(:developer) }
              .to(change { user.reload.roles.count }.by(-1))
          end
        end

        context 'when role does not exist' do
          it 'does not remove role' do
            expect { subject.remove(:mentor) }
              .not_to(change { user.reload.roles.count })
          end
        end
      end

      describe '#has?' do
        context 'role exists' do
          specify { expect(subject.has?(:developer)).to be true }
        end

        context 'role does not exist' do
          specify { expect(subject.has?(:mentor)).to be false }
        end
      end

      describe '#role_for' do
        before do
          user.add_role :mentor
        end

        context 'user has required role' do
          it 'returns mentor role' do
            expect(subject.role_for(:mentor)).to be_kind_of Roles::Mentor
          end
        end

        context 'user does not have role' do
          it 'returns nil' do
            expect(subject.role_for(:staff)).to eq nil
          end
        end
      end
    end
  end
end
