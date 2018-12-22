# frozen_string_literal: true

require 'rails_helper'

describe Ops::Author::SignUp do
  describe '.call' do
    context 'valid params' do
      let(:params) do
        {
          email: 'user@symbiod.org',
          password: 'password',
          first_name: 'John',
          last_name: 'Smith',
          location: 'Russia',
          timezone: 'Europe/Moscow'
        }
      end

      it 'creates new user' do
        expect { described_class.call(params: params) }
          .to change { User.count }.by(1)
      end

      it 'assigns author role' do
        described_class.call(params: params)
        expect(User.last.has_role?(:author)).to eq true
      end
    end

    context 'invalid params' do
      let(:params) do
        {
          email: ''
        }
      end

      it 'does not create new user' do
        expect { described_class.call(params: params) }
          .not_to(change { User.count })
      end
    end
  end
end
