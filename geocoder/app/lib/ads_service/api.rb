# frozen_string_literal: true

module AdsService
  module Api
    def update_coords(id, coords)
      response = connection.put("ads/#{id}") do |request|
        request.params = { lat: coords[0], lon: coords[1] }
        request.headers['AUTHORIZATION'] = Settings.app.secret
      end

      Application.logger.info(
        'sending request to update ad coordinates',
        ad_id: id,
        coordinates: coords,
        success: response.success?
      )
    end
  end
end
