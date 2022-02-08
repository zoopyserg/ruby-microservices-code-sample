# frozen_string_literal: true

require 'dry/initializer'
require_relative 'api'

module AdsService
  class Client
    extend Dry::Initializer[undefined: false]
    include Api

    option :url, default: proc { 'http://localhost:3000/api/v1' }
    option :connection, default: proc { build_connection }

    private

    def build_connection
      Faraday.new(@url) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
