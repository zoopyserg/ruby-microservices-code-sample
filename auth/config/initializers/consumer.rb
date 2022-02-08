# frozen_string_literal: true

channel = RabbitMQ.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('auth', durable: true)

queue.subscribe(manual_ack: true) do |_, properties, payload|
  payload = JSON.parse(payload)
  extracted_token = begin
                      JwtEncoder.decode(payload['token'])
                    rescue JWT::DecodeError
                      {}
                    end
  result = Auth::FetchUserService.call(extracted_token['uuid'])
  user_id = result.success? ? result.user.id : nil

  Application.logger.info(
    'authenticate user',
    uuid: extracted_token['uuid'],
    user_id: user_id
  )

  exchange.publish(
    { user_id: user_id }.to_json,
    routing_key: properties.reply_to,
    headers: {
      app_id: Settings.app.name,
      request_id: Thread.current[:request_id],
      correlation_id: properties.headers['correlation_id']
    }
  )
end
