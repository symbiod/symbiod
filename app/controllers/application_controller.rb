# frozen_string_literal: true

# Base controller of application
class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery prepend: true, with: :exception
  before_action :set_locale

  # Invoked when sorcery filter `require_login` returns false
  # All unauthenticated users are redirected to root landing
  def not_authenticated
    redirect_to root_landing_url
  end

  private

  def set_locale
    I18n.locale = session[:locale] || :en
  end
end
