# frozen_string_literal: true

require 'sinatra/extension'

module ApiErrors
  extend Sinatra::Extension

  class Unauthorized < StandardError; end

  error Geocoder::NotFound do
    status 404
    json(
      errors: [
        {
          detail: I18n.t(:not_found, scope: 'services.geocoder.find_service')
        }
      ]
    )
  end

  error Unauthorized do
    status 403
    json(
      errors: [
        {
          detail: I18n.t(:unauthorized, scope: 'api.errors')
        }
      ]
    )
  end
end
