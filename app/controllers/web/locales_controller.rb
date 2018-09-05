module Web
  class LocalesController < ApplicationController
    def toggle
      I18n.locale == :en ? change_locale(:ru) : change_locale(:en)
      redirect_to root_url
    end

    private

    def change_locale(locale)
      I18n.locale = locale
      session[:locale] = locale
    end
  end
end
