# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::IdeaStatusButton do
  subject { described_class.new(idea, context: { controller: controller }).idea_status }

  controller Web::Dashboard::IdeasController

  set_current_user

  context 'current user staff or mentor' do
    let(:current_user) { create(:user, %i[staff mentor].sample, :active) }

    context 'idea status active' do
      let(:idea) { create(:idea, :active) }

      it 'renders active status' do
        expect(subject).to match(/active/)
      end

      it 'renders success color link' do
        expect(subject).to match(/<a class="btn btn-success btn-sm"/)
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

      it 'renders pending status' do
        expect(subject).to match(/pending/)
      end

      it 'renders warning color link' do
        expect(subject).to match(/<a class="btn btn-warning btn-sm"/)
      end

      it 'renders link to activate' do
        expect(subject).to match(/activate/)
      end

      it 'renders link to confirm status to activate' do
        expect(subject).to match(/data-confirm="Are you sure to activate/)
      end
    end

    context 'idea status disabled' do
      let(:idea) { create(:idea, :disabled) }

      it 'renders disabled status' do
        expect(subject).to match(/disabled/)
      end

      it 'renders danger color link' do
        expect(subject).to match(/<a class="btn btn-danger btn-sm"/)
      end

      it 'renders link to activate' do
        expect(subject).to match(/activate/)
      end

      it 'renders link to confirm status to disable' do
        expect(subject).to match(/data-confirm="Are you sure to activate/)
      end
    end

    context 'idea status rejected' do
      let(:idea) { create(:idea, :rejected) }

      it 'renders rejected status' do
        expect(subject).to match(/rejected/)
      end

      it 'renders danger color button' do
        expect(subject).to match(/<a class="btn btn-danger btn-sm/)
      end

      it 'renders disabled button' do
        expect(subject).to match(/<a class="btn btn-danger btn-sm disabled"/)
      end
    end
  end

  context 'current user author or developer' do
    let(:current_user) { create(:user, %i[author developer].sample, :active) }
    let(:idea) { create(:idea, :active) }

    it 'renders idea status as text' do
      expect(subject).to eq 'active'
    end
  end
end
