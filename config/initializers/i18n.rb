if Spree::Config.instance
  Spree::Config.set(:default_locale => 'ru')
end
I18n.locale = "ru"
I18n.default_locale = "ru" 
