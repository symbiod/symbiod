# frozen_string_literal: true

# Base controller of application
class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery prepend: true, with: :exception

  private

  def require_login?
    redirect_to root_url unless current_user
  end
end
