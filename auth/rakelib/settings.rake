# frozen_string_literal: true

task :settings do
  require 'config'
  require_relative '../config/initializers/config'
  require 'i18n'

  I18n.available_locales = [:en]
  I18n.default_locale = :en
end
