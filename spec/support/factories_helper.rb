# frozen_string_literal: true

module FactoriesHelper
  def valid_user_attributes
    attributes_for(:user).reject do |(k, _)|
      %i[password salt state crypted_password email].include?(k)
    end
  end
end
