# frozen_string_literal: true

require 'rails_helper'

describe Web::Bootcamp::JoinButton do
  subject { described_class.new(wizard, params).call(:show) }
  let(:params) { { current_wizard_step_url: current_wizard_step_url, context: { controller: controller } } }
  let(:wizard) { Member::Wizard.new(member) }
  let(:current_wizard_step_url) { public_send(wizard.route_for_current_step) }

  controller Web::Bootcamp::HomeController

  context 'when signed in' do
    context 'when wizard is not completed' do
      let(:member) { create(:user, :member, :pending) }

      it 'renders link to current wizard step' do
        expect(subject).to(match(%r{\/}))
      end
    end

    context 'when wizard is completed' do
      let(:member) { create(:user, :member, :active) }

      it 'renders link to dashboard' do
        expect(subject).to(match(%r{\/}))
      end
    end

    context 'when user is finished wizard and can not access dashboard' do
      let(:member) { create(:user, :member, :rejected) }
      it 'displays alert' do
        expect(subject).to(match(I18n.t('bootcamp.landing.account_disabled')))
      end
    end
  end

  context 'when is guest' do
    let(:member) { nil }

    it 'renders link to github sign in' do
      expect(subject)
        .to eq '<a id="join-via-github" class="btn btn-lg btn-secondary"' \
               " href=\"http://test.host/bootcamp/oauth/github\">#{I18n.t('bootcamp.landing.github_login')}</a>\n"
    end
  end
end
