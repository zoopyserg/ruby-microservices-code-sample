# frozen_string_literal: true

module RabbitMQ
  extend self

  @mutex = Mutex.new

  def connection
    @mutex.synchronize do
      @connection ||= Bunny.new.start
    end
  end

  def consumer_channel
    Thread.current[:rabbitmq_consumer_channel] ||= connection.create_channel(
      nil,
      Settings.rabbit_mq.consumer_pool
    )
  end
end
