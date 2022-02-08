# frozen_string_literal: true

require_relative '../../lib/auth_service/client'
require_relative '../../lib/auth_service/rpc_client'

module Auth
  class Unauthorized < StandardError; end
  AUTH_TOKEN = %r{\ABearer (?<token>.+)\z}.freeze

  def user_id
    user_id = case ENV['AUTH_METHOD']
              when 'sync_http'
                http_auth_service.auth(matched_token)
              when 'sync_rpc'
                rpc_auth_service.auth(matched_token)
              end
    raise Unauthorized unless user_id

    user_id
  end

  private

  def http_auth_service
    @auth_service ||= AuthService::Client.new
  end

  def rpc_auth_service
    @rpc_auth_service ||= AuthService::RpcClient.fetch
  end

  def matched_token
    result = auth_headers&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end

  def auth_headers
    request.env['HTTP_AUTHORIZATION']
  end
end
