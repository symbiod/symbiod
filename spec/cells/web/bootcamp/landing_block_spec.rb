# frozen_string_literal: true

require 'rails_helper'

describe Web::Bootcamp::LandingBlock do
  subject { described_class.new(translation, context: { controller: controller }).call(:show) }
  let(:translation) { 'bootcamp.landing.who' }

  controller Web::Bootcamp::HomeController

  it 'render the title' do
    expect(subject).to match(/#{I18n.t('bootcamp.landing.who.title')}/)
  end

  it 'render the body' do
    expect(subject).to match(/#{I18n.t('bootcamp.landing.who.title')}/)
  end
end
