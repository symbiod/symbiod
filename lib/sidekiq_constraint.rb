class SidekiqConstraint
  def matches?(request)
    return false unless request.session[:user_id]
    user = User.find request.session[:user_id]
    user && user.has_role?(:stuff)
  end
end
