# frozen_string_literal: true

module Web
  # This controller is located in root namespace to allow any kind of user
  # to sighn out from the system, since we have different sign in logic in
  # different namespaces
  class SignOutsController < ApplicationController
    def destroy
      logout
      reset_sorcery_session
      # NOTICE: For some reason Sorcery does not sign out properly
      # So we need to manualy nullify current user variable
      @current_user = nil
      redirect_back_or_to(root_landing_url, notice: t('landing.logout'))
    end
  end
end
