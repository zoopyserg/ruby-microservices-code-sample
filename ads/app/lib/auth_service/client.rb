# frozen_string_literal: true

require 'dry/initializer'
require_relative '../base_faraday_service'
require_relative 'api'

module AuthService
  class Client
    extend Dry::Initializer[undefined: false]
    include BaseFaradayService
    include Api

    option :url, default: proc { 'http://localhost:4000/api/v1' }
    option :connection, default: proc { build_connection }
  end
end
