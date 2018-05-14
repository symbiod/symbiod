# frozen_string_literal: true

require 'rails_helper'

describe MarkdownHelper do
  let(:text) { '**You have the**: [Code](https://test.com/)' }
  let(:result) { "<p><strong>You have the</strong>: <a href=\"https://test.com/\">Code</a></p>\n" }

  it 'render markdown text correct' do
    expect(markdown(text)).to eq result
  end
end
