# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::IdeaStatusButton do
  subject { described_class.new(idea, context: { controller: controller }).link_to_status(confirm: idea.state) }

  controller Web::Dashboard::IdeasController

  context 'idea status voting' do
    let(:idea) { create(:idea, :voting) }

    it 'renders success color link' do
      expect(subject).to match(/<a class="btn btn-warning btn-sm"/)
    end

    it 'renders link to activate' do
      expect(subject).to match(/activate/)
    end

    it 'renders link to confirm status to activate' do
      expect(subject).to match(/data-confirm="Are you sure you want to activate?/)
    end
  end

  context 'idea status active' do
    let(:idea) { create(:idea, :active) }

    it_behaves_like 'button status is active'
  end

  context 'idea status pending' do
    let(:idea) { create(:idea, :pending) }

    it 'renders warning color link' do
      expect(subject).to match(/<a class="btn btn-danger btn-sm"/)
    end

    it 'renders link to voting' do
      expect(subject).to match(/voting/)
    end

    it 'renders link to confirm status to activate' do
      expect(subject).to match(/data-confirm="Are you sure you want to vote?/)
    end
  end

  context 'idea status disabled' do
    let(:idea) { create(:idea, :disabled) }

    it_behaves_like 'button status is disabled'
  end

  context 'idea status rejected' do
    let(:idea) { create(:idea, :rejected) }

    it_behaves_like 'button status is rejected'
  end
end
