require_relative 'config/environment'

use Rack::RequestId
use Rack::Ougai::LogRequests, Application.logger

map '/api/v1' do
  run Application
end
