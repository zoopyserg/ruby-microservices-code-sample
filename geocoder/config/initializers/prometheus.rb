# frozen_string_literal: true

require 'prometheus/client'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

Metrics.configure do |registry|
  registry.histogram(
    :geocoding_process_time,
    docstring: 'Time of geocoing process',
    labels: %i[result]
  )
end
