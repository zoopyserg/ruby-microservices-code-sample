# frozen_string_literal: true

module Auth
  class FetchUserService
    prepend BasicService

    param :uuid

    attr_reader :user

    def call
      return fail!(I18n.t(:forbidden, scope: 'services.auth.fetch_user_service')) if @uuid.nil? || session.nil?

      Application.logger.info(
        'authenticated user',
        user_id: session.user.id,
        session_uuid: session.uuid
      )
      @user = session.user
    end

    private

    def session
      @session ||= UserSession.find(uuid: @uuid)
    rescue => e
      raise unless e.cause.is_a?(PG::InvalidTextRepresentation)
    end
  end
end
