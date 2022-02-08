# frozen_string_literal: true

module FixturesHelper
  def fixtures_path
    File.expand_path('../fixtures', __dir__)
  end
end

RSpec.configure do |config|
  config.include FixturesHelper
end