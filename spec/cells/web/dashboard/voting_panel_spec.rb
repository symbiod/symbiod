# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::VotingPanel do
  subject { described_class.new(idea, context: { controller: controller }) }

  controller Web::Dashboard::VotesController

  set_current_user

  context 'current user can vote' do
    let(:idea) { create(:idea, :voting) }
    let(:current_user) { create(:user, :developer, :active) }

    it 'renders success color link up vote' do
      expect(subject.render_vote_action('up')).to match(/<a class="btn btn-success btn-sm"/)
    end

    it 'renders link to up vote' do
      expect(subject.render_vote_action('up')).to match(%r{/up})
    end

    it 'renders danger color link down vote' do
      expect(subject.render_vote_action('down')).to match(/<a class="btn btn-danger btn-sm"/)
    end

    it 'renders link to down vote' do
      expect(subject.render_vote_action('down')).to match(%r{/down})
    end
  end

  context 'current user can not vote' do
    let(:idea) { create(:idea, :voting) }
    let(:current_user) { create(:user, :author, :active) }

    it 'renders disabled link up vote' do
      expect(subject.render_vote_action('up')).to eq 'up'
    end

    it 'renders disabled link down vote' do
      expect(subject.render_vote_action('down')).to eq 'down'
    end
  end
end
