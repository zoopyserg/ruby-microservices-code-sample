module AuthService
  module Api
    def auth(token)
      response = connection.get('auth') do |request|
        request.headers['Authorization'] = "Bearer #{token}"
      end

      response.body.dig('meta', 'user_id') if response.success?
      ApplicationController.logger.info(
        'sending auth request via HTTP',
        token: token,
        success: response.success?,
        user_id: response.success? ? response.body.dig('meta', 'user_id') : nil
      )
    end
  end
end
