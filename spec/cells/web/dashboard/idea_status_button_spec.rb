# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::IdeaStatusButton do
  subject { described_class.new(idea, context: { controller: controller }).idea_status }

  controller Web::Dashboard::IdeasController

  context 'idea status voting' do
    let(:idea) { create(:idea, :voting) }

    it 'renders success color link' do
      expect(subject).to match(/<a class="btn btn-success btn-sm"/)
    end

    it 'renders link to activate' do
      expect(subject).to match(/activate/)
    end

    it 'renders link to confirm status to activate' do
      expect(subject).to match(/data-confirm="Are you sure to active/)
    end
  end

  context 'idea status active' do
    let(:idea) { create(:idea, :active) }

    it 'renders success color link' do
      expect(subject).to match(/<a class="btn btn-danger btn-sm"/)
    end

    it 'renders link to disable' do
      expect(subject).to match(/deactivate/)
    end

    it 'renders link to confirm status to disable' do
      expect(subject).to match(/data-confirm="Are you sure to disable/)
    end
  end

  context 'idea status pending' do
    let(:idea) { create(:idea, :pending) }

    it 'renders warning color link' do
      expect(subject).to match(/<a class="btn btn-warning btn-sm"/)
    end

    it 'renders link to voting' do
      expect(subject).to match(/voting/)
    end

    it 'renders link to confirm status to activate' do
      expect(subject).to match(/data-confirm="Are you sure to voting/)
    end
  end

  context 'idea status disabled' do
    let(:idea) { create(:idea, :disabled) }

    it 'renders danger color link' do
      expect(subject).to match(/<a class="btn btn-success btn-sm"/)
    end

    it 'renders link to activate' do
      expect(subject).to match(/activate/)
    end

    it 'renders link to confirm status to activate' do
      expect(subject).to match(/data-confirm="Are you sure to active/)
    end
  end

  context 'idea status rejected' do
    let(:idea) { create(:idea, :rejected) }

    it 'renders success color button' do
      expect(subject).to match(/<a class="btn btn-success btn-sm/)
    end

    it 'renders disabled button' do
      expect(subject).to match(/<a class="btn btn-success btn-sm disabled"/)
    end
  end
end
