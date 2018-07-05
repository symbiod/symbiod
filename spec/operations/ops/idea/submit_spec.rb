# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::Submit do
  subject { described_class }

  describe '.call' do
    let(:author) { create(:user, :author) }
    let(:idea) { create(:idea) }
    let(:message) { 'Idea was added' }

    context 'valid profile data provided' do
      let(:params) do
        {
          name: 'name',
          description: 'description',
          private_project: true,
          skip_bootstrapping: false
        }
      end

      it 'create idea' do
        expect { subject.call(params: params, author: author) }.to change(::Idea, :count).by(1)
      end

      it 'calls job SlackMessage' do
        expect(SlackMessageJob)
          .to receive(:perform_later)
        subject.call(author: author, params: params)
      end
    end

    context 'invalid provided data' do
      let(:invalid_params) do
        {
          name: nil
        }
      end

      it 'does not create idea' do
        expect { subject.call(params: invalid_params, author: author) }.to change(::Idea, :count).by(0)
      end

      it 'does not calls job SlackMessage' do
        expect(SlackMessageJob)
          .not_to receive(:perform_later)
        subject.call(author: author, params: invalid_params)
      end
    end
  end
end
