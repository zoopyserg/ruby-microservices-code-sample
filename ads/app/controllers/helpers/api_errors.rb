# frozen_string_literal: true

require 'sinatra/extension'
require_relative 'auth'

module ApiErrors
  extend Sinatra::Extension

  helpers do
    def error_response(error_messages, code)
      status code
      errors = case error_messages
               when ActiveRecord::Base
                 ErrorSerializer.from_model(error_messages)
               else
                 ErrorSerializer.from_messages(error_messages)
               end

      errors.to_json
    end
  end

  error Auth::Unauthorized do
    error_response('Unauthorized', 403)
  end
end
