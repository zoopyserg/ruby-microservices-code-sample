# frozen_string_literal: true

class UserRoutes < Application
  helpers Validations

  post '/' do
    user_params = validate_with!(UserParamsContract)

    result = Users::CreateService.call(*user_params.to_h.values)

    if result.success?
      status 201
    else
      status 422
      error_response result.user
    end
  end
end
