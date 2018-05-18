# frozen_string_literal: true

require 'spec_helper'
require './app/models/developer/wizard'

describe Developer::Wizard do
  subject { described_class.new(user) }
  let(:user) { double(state: state) }
  let(:state) { :pending }

  describe '#completed?' do
    context 'user is pending' do
      let(:state) { :pending }
      specify { expect(subject.completed?).to eq false }
    end

    context 'user is active' do
      let(:state) { :active }
      specify { expect(subject.completed?).to eq true }
    end
  end

  describe '#active?' do
    context 'user is pending' do
      let(:state) { :pending }
      specify { expect(subject.active?).to eq true }
    end

    context 'user is active' do
      let(:state) { :active }
      specify { expect(subject.active?).to eq false }
    end
  end

  describe '#route_for_current_step' do
    context 'user is pending' do
      let(:state) { :pending }

      it 'returns url helper name for specified step' do
        expect(subject.route_for_current_step).to eq 'edit_bootcamp_wizard_profile_url'
      end
    end

    context 'user is profile_completed' do
      let(:state) { :profile_completed }

      it 'returns url helper name for specified step' do
        expect(subject.route_for_current_step).to eq 'bootcamp_wizard_screenings_url'
      end
    end

    context 'user is screening_completed' do
      let(:state) { :profile_completed }

      it 'returns url helper name for specified step' do
        expect(subject.route_for_current_step).to eq 'bootcamp_wizard_screenings_url'
      end
    end
  end

  describe '#steps' do
    let(:wizard_steps) { %i[pending profile_completed screening_completed] }
    specify { expect(subject.steps).to match wizard_steps }
  end
end
