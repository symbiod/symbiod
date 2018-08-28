# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::SkillStatusButton do
  subject { described_class.new(skill, context: { controller: controller }).link_to_status(confirm: skill.state) }

  controller Web::Dashboard::SkillsController

  set_current_user

  context 'current user staff or mentor' do
    let(:current_user) { create(:user, %i[staff mentor].sample, :active) }

    context 'skill status active' do
      let(:skill) { create(:skill) }

      it_behaves_like 'button status is active'
    end

    context 'skill status disabled' do
      let(:skill) { create(:skill, :disabled) }

      it_behaves_like 'button status is disabled'
    end
  end
end
