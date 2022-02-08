# frozen_string_literal: true

require 'sinatra/custom_logger'

class Application < Sinatra::Base
  helpers Sinatra::CustomLogger
  use Rack::JSONBodyParser

  configure do
    register Sinatra::Namespace
    register ApiErrors

    set :app_file, File.expand_path('../config.ru', __dir__)
  end

  configure :development do
    register Sinatra::Reloader

    set :show_exceptions, false
  end

  before do
    raise ApiErrors::Unauthorized unless request.env['HTTP_AUTHORIZATION'] == Settings.app.secret
  end

  post '/geocoder' do
    city = Geocoder::FindService.geocode(params[:city])
    raise Geocoder::NotFound unless city

    json(meta: { lat: city[0], lon: city[1] })
  end
end
