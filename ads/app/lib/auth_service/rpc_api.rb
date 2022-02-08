# frozen_string_literal: true

module AuthService
  module RpcApi
    def auth(token)
      payload = { token: token }.to_json

      ApplicationController.logger.info('calling rpc auth', token: token)
      publish(payload, type: 'fetch_user')
      user_id
    end
  end
end
