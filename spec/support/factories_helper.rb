module FactoriesHelper
  def valid_user_attributes
    attributes_for(:user).reject do |(k, _)|
      [:password, :salt, :state, :crypted_password, :email].include?(k)
    end
  end
end
