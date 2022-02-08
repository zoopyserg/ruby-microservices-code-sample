# frozen_string_literal: true

module RabbitMQ
  extend self

  @mutex = Mutex.new

  def connection
    @mutex.synchronize do
      @connection ||= Bunny.new(
        host: ENV['RABBITMQ_HOST'],
        username: ENV['RABBITMQ_USER'],
        password: ENV['RABBITMQ_PASSWORD']
      ).start
    end
  end

  def channel
    Thread.current[:rabbitmq_channel] ||= connection.create_channel
  end

  def consumer_channel
    Thread.current[:rabbitmq_consumer_channel] ||= connection.create_channel(
      nil,
      ENV['RABBIT_MQ_CONSUMER_POOL']
    )
  end
end
