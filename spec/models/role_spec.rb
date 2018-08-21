# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'validations' do
    subject { build(:role) }

    it { is_expected.to validate_inclusion_of(:type).in_array(Rolable.role_class_names) }
  end

  describe '#name' do
    let(:role) { build(:role) }
    let(:stubbed_name) { 'Some name' }

    before do
      allow(Roles::RolesManager)
        .to receive(:role_name_by_type)
        .with(Role)
        .and_return(stubbed_name)
    end

    its(:name) { is_expected.to eq stubbed_name }
  end

  describe '#is?' do
    let(:role) { build(:role) }
    let(:stubbed_name) { 'Some name' }

    before do
      allow(Roles::RolesManager)
        .to receive(:role_name_by_type)
        .with(Role)
        .and_return(stubbed_name)
    end

    context 'role name matched' do
      let(:role_name) { 'Some name' }

      it 'returns true' do
        expect(subject.is?(role_name)).to eq true
      end
    end

    context 'role name not matched' do
      let(:role_name) { 'Some name not matched' }

      it 'returns true' do
        expect(subject.is?(role_name)).to eq false
      end
    end
  end
end
