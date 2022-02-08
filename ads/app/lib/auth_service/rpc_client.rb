# frozen_string_literal: true

require_relative '../rabbit_mq'
require_relative 'rpc_api'

module AuthService
  class RpcClient
    include RabbitMQ
    include RpcApi
    extend Dry::Initializer[undefined: false]

    option :queue, default: -> { create_queue }
    option :reply_queue, default: -> { create_reply_queue }
    option :lock, default: -> { Mutex.new }
    option :condition, default: -> { ConditionVariable.new }

    def self.fetch
      Thread.current['rpc_client'] ||= new.start
    end

    def start
      @reply_queue.subscribe do |_, properties, payload|
        next unless properties.headers['correlation_id'] == @correlation_id

        @user_id = JSON.parse(payload)['user_id']
        ApplicationController.logger.info('rpc answer to auth request', user_id: @user_id)
        @lock.synchronize { @condition.signal }
      end

      self
    end

    private

    attr_reader :user_id

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMQ.channel
      channel.queue('auth', durable: true)
    end

    def create_reply_queue
      channel = RabbitMQ.channel
      channel.queue('amq.rabbitmq.reply-to')
    end

    def publish(payload, opts = {})
      self.correlation_id = SecureRandom.uuid

      @lock.synchronize do
        @queue.publish(
          payload,
          opts.merge(
            app_id: 'auth',
            headers: {
              request_id: Thread.current[:request_id],
              correlation_id: @correlation_id
            },
            reply_to: @reply_queue.name
          )
        )
        @condition.wait(@lock)
      end
    end
  end
end
