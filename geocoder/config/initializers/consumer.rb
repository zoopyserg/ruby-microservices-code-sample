# frozen_string_literal: true

channel = RabbitMQ.consumer_channel
queue = channel.queue('geocoding', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  payload = JSON(payload)
  Thread.current[:request_id] = properties.headers['request_id']
  coordinates = Geocoder::FindService.geocode(payload['city'])

  Application.logger.info(
    'geocoded coordinates',
    city: payload['city'],
    coordinates: coordinates
  )

  AdsService::Client.new.update_coords(payload['id'], coordinates)

  channel.ack(delivery_info.delivery_tag)
end
