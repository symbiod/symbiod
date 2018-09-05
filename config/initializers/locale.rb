I18n.available_locales = [:en, :ru]
default_locale = :ru
I18n.default_locale = Rails.env.production? || Rails.env.development? ? default_locale : (I18n.available_locales - [default_locale]).first
