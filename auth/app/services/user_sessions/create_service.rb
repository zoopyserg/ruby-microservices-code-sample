# frozen_string_literal: true

module UserSessions
  class CreateService
    prepend BasicService

    param :email
    param :password
    option :user, default: proc { User.find(email: @email) }, reader: false

    attr_reader :session

    def call
      validate
      create_session unless failure?
    end

    private

    def validate
      return fail_t!(:unauthorized) unless @user&.authenticate(@password)
    end

    def create_session
      @session = UserSession.new

      if @session.valid?
        @user.add_session(@session)
        Application.logger.info(
          'created new user session',
          user_id: @user.id,
          session_uuid: @session.uuid
        )
      else
        fail!(@session.errors)
      end
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'services.user_sessions.create_service'))
    end
  end
end
