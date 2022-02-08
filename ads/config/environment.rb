# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
require 'dotenv'
Dotenv.load

Bundler.require(:default, ENV['RACK_ENV'])

# Load the app models and controllers
require_all 'app/**/*.rb'

ActiveRecord::Base.logger = ApplicationController.logger

use Rack::RequestId
use Rack::Ougai::LogRequests, ApplicationController.logger
use Rack::JSONBodyParser

use ApplicationController
use AdsController
