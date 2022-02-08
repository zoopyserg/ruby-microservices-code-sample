# frozen_string_literal: true

module GeocoderService
  module Api
    def geocode_by_http(id, city)
      ApplicationController.logger.info('sending data to geocoder via HTTP', ad_id: id, city: city)
      response = connection.post('geocoder') do |request|
        request.params = { city: city }
        request.headers['AUTHORIZATION'] = ENV['GEOCODER_SECRET']
      end

      response.body.dig('meta') if response.success?
    end

    def geocode_by_queue(id, city)
      payload = {
        id: id,
        city: city,
        type: 'geocode'
      }.to_json

      ApplicationController.logger.info('sending data to geocoder via RabbitMQ', ad_id: id, city: city)
      publish(payload)
    end
  end
end
