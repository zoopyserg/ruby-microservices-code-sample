# frozen_string_literal: true

require 'csv'

module Geocoder
  class NotFound < StandardError; end

  module FindService
    extend self

    DATA_PATH = File.expand_path('../../../db/data/city.csv', __dir__)

    def geocode(city)
      data[city]
    end

    def data
      @data ||= load_data!
    end

    private

    def load_data!
      @data = CSV.read(DATA_PATH, headers: true).inject({}) do |result, row|
        city = row['city']
        lat = row['geo_lat'].to_f
        lon = row['geo_lon'].to_f
        result[city] = [lat, lon]
        result
      end
    end
  end
end
