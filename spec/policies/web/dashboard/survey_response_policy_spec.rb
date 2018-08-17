# frozen_string_literal: true

require 'rails_helper'

describe Dashboard::SurveyResponsePolicy do
  subject { described_class.new(user, nil) }

  shared_examples 'allow index and show' do
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
  end

  shared_examples 'denied index and show' do
    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:show) }
  end

  context 'user has feedback' do
    before { create(:survey_response, user: user) }

    shared_examples 'denied create feedback' do
      it { is_expected.not_to permit_action(:new) }
      it { is_expected.not_to permit_action(:create) }
    end

    context 'user has role staff or mentor' do
      let(:user) { create(:user, :staff_or_mentor, :active) }

      it_behaves_like 'allow index and show'
      it_behaves_like 'denied create feedback'
    end

    context 'user has role developer or author' do
      let(:user) { create(:user, :developer_or_author, :active) }

      it_behaves_like 'denied index and show'
      it_behaves_like 'denied create feedback'
    end
  end

  context 'user has not feedback' do
    shared_examples 'allow create feedback' do
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
    end

    context 'user has role staff or mentor' do
      let(:user) { create(:user, :staff_or_mentor, :active) }

      it_behaves_like 'allow index and show'
      it_behaves_like 'allow create feedback'
    end

    context 'user has role developer or author' do
      let(:user) { create(:user, :developer_or_author, :active) }

      it_behaves_like 'denied index and show'
      it_behaves_like 'allow create feedback'
    end
  end
end
