# frozen_string_literal: true

require 'sinatra/custom_logger'

require_relative 'helpers/auth'
require_relative 'helpers/api_errors'
require_relative 'helpers/pagination'

APP_ROOT = Pathname.new(File.expand_path('../../', __dir__))
class ApplicationController < Sinatra::Base
  helpers Sinatra::CustomLogger
  register Sinatra::Namespace
  register Sinatra::StrongParams
  register Sinatra::ActiveRecordExtension
  register ApiErrors
  include Pagination
  include Auth

  configure do |app|
    set :root, APP_ROOT.to_path
    set :server, :puma

    logger_output = app.environment == :production ? STDOUT : app.root.concat('/', ENV['LOG_PATH'])
    logger = Ougai::Logger.new(
      logger_output,
      level: ENV['LOG_LEVEL']
    )

    logger.before_log = lambda do |data|
      data[:service] = { name: ENV['APP_NAME'] }
      data[:request_id] ||= Thread.current[:request_id]
    end

    app.set :logger, logger
  end

  configure :development do |app|
    register Sinatra::Reloader

    set :show_exceptions, false
    app.logger.formatter = Ougai::Formatters::Readable.new
  end

  before { content_type 'application/json' }
end
