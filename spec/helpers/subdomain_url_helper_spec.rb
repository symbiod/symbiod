# frozen_string_literal: true

require 'rails_helper'

describe SubdomainUrlHelper do
  describe '.nav_link' do
    let(:link_text) { 'Some Link' }
    let(:link_url)  { 'https://google.com' }

    before { controller.request.host = "#{current_domain}.host.com" }

    context 'id provided' do
      let(:current_domain) { 'www' }
      let(:id) { 'some-id' }

      it do
        expect(helper.nav_link(link_text, link_url, id: id, subdomain: 'www'))
          .to eq '<a class="nav-link active" id="some-id" href="https://google.com">Some Link</a>'
      end
    end

    context 'current subdomain' do
      let(:current_domain) { 'www' }

      it do
        expect(helper.nav_link(link_text, link_url, subdomain: 'www'))
          .to eq '<a class="nav-link active" id="" href="https://google.com">Some Link</a>'
      end

      context 'the default domain is www' do
        it do
          expect(helper.nav_link(link_text, link_url, subdomain: 'www'))
            .to eq '<a class="nav-link active" id="" href="https://google.com">Some Link</a>'
        end
      end
    end

    context 'other subdomain' do
      let(:current_domain) { 'other' }

      it do
        expect(helper.nav_link(link_text, link_url, subdomain: 'www'))
          .to eq '<a class="nav-link " id="" href="https://google.com">Some Link</a>'
      end
    end
  end

  describe '.root_landing_url' do
    specify { expect(helper.root_landing_url).to eq 'http://www.test.host/' }
  end
end
