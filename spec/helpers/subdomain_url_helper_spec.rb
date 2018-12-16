# frozen_string_literal: true

require 'rails_helper'

describe SubdomainUrlHelper do
  describe '.nav_link' do
    let(:link_text) { 'Some Link' }
    let(:link_url)  { 'https://google.com' }

    before { controller.request.host = "host.com#{current_slug}" }

    context 'id provided' do
      let(:current_slug) { '/' }
      let(:id) { 'some-id' }

      it do
        expect(helper.nav_link(link_text, link_url, id: id))
          .to eq '<a class="nav-link active" id="some-id" href="https://google.com">Some Link</a>'
      end
    end

    context 'current slug' do
      let(:current_slug) { '/bootcamp' }

      it do
        expect(helper.nav_link(link_text, link_url, slug: 'bootcamp'))
          .to eq '<a class="nav-link active" id="" href="https://google.com">Some Link</a>'
      end
    end

    context 'other subdomain' do
      let(:current_slug) { '/other' }

      it do
        expect(helper.nav_link(link_text, link_url, slug: 'bootcamp'))
          .to eq '<a class="nav-link " id="" href="https://google.com">Some Link</a>'
      end
    end
  end

  describe '.root_landing_url' do
    specify { expect(helper.root_landing_url).to eq 'http://test.host/' }
  end
end
