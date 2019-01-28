# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'button status is active' do
  it 'renders active status' do
    expect(subject).to match(/active/)
  end

  it 'renders success color link' do
    expect(subject).to match(/<a class="btn btn-success btn-sm"/)
  end

  it 'renders link to disable' do
    expect(subject).to match(/deactivat/)
  end

  it 'renders link to confirm status to disable' do
    expect(subject).to match(/data-confirm="Are you sure you want to disable?/)
  end
end

RSpec.shared_examples 'button status is disabled' do
  it 'renders active status' do
    expect(subject).to match(/disabled/)
  end

  it 'renders danger color link' do
    expect(subject).to match(/<a class="btn btn-danger btn-sm"/)
  end

  it 'renders link to activate' do
    expect(subject).to match(/activate/)
  end

  it 'renders link to confirm status to activate' do
    expect(subject).to match(/data-confirm="Are you sure you want to activate?/)
  end
end

RSpec.shared_examples 'danger and disabled' do
  it 'renders danger color button' do
    expect(subject).to match(/<a class="btn btn-danger btn-sm/)
  end

  it 'renders disabled button' do
    expect(subject).to match(/<a class="btn btn-danger btn-sm disabled"/)
  end
end

RSpec.shared_examples 'button status is pending' do
  it 'renders pending status' do
    expect(subject).to match(/pending/)
  end

  it_behaves_like 'danger and disabled'
end

RSpec.shared_examples 'button status is rejected' do
  it 'renders pending status' do
    expect(subject).to match(/rejected/)
  end

  it_behaves_like 'danger and disabled'
end
