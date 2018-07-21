# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::SkillStatusButton do
  subject { described_class.new(skill, context: { controller: controller }).skill_status }

  controller Web::Dashboard::SkillsController

  set_current_user

  context 'current user staff or mentor' do
    let(:current_user) { create(:user, %i[staff mentor].sample, :active) }

    context 'skill status active' do
      let(:skill) { create(:skill) }

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

    context 'skill status disabled' do
      let(:skill) { create(:skill, :disabled) }

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
        expect(subject).to match(/data-confirm="Are you sure to active/)
      end
    end
  end
end
