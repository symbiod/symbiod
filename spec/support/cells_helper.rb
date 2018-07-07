# frozen_string_literal: true

module CellsHelper
  def set_current_user
    before { allow(controller).to receive(:current_user).and_return(current_user) }
  end
end
