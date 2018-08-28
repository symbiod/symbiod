# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::BaseStatusButton do
  subject { described_class.new(model.role(:member)) }
  let(:model) { create(:user, :member, :active) }

  it 'raises error' do
    expect { subject.link_to_status }.to raise_error('Implement in child class')
  end
end
