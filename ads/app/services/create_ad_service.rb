# frozen_string_literal: true

require_relative 'basic_service'

class CreateAdService
  prepend BasicService

  option :ad, optional: true do
    option :title
    option :description
    option :city
  end

  option :user_id, optional: true

  attr_reader :ad

  def call
    @ad = ::Ad.new(@ad.to_h.merge({ user_id: @user_id }))
    fail!(@ad.errors) unless @ad.save

    case ENV['GEOCODE_METHOD']
    when 'sync_http'
      update_coords
    when 'async_publish_to_queue'
      ::GeocoderService::Client.new.geocode_by_queue(ad.id, ad[:city])
    end
  end

  private

  def update_coords
    result = ::GeocoderService::Client.new.geocode_by_http(ad.id, ad[:city])
    return unless result

    ad.update(lat: result['lat'], lon: result['lon'])
    ApplicationController.logger.info('updated ad coordinates', ad_id: ad.id, lat: result['lat'], lon: result['lon'])
  end
end
