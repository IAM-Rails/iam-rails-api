# frozen_string_literal: true

module V1
  module Resources
    class Auth < Base
      resource :auth do
        params do
          requires :name, type: String
          requires :email, type: String
          requires :password, type: String
        end
        post :register do
          user = ::Users::Register.call(params: permitted_params)

          present user, with: Entities::User, with_api_key: true
        end

        params do
          requires :email, type: String
          requires :password, type: String
        end
        post :login do
          user = User.find_by(email: permitted_params[:email].downcase)
          error!("Forbidden", 403) unless user

          valid = user.authenticate(params[:password])
          error!("Forbidden", 403) unless valid

          ::ApiKeys::FromUser.call(user_id: user.id)

          present user, with: Entities::User, with_access_token: true
        end

        post :logout do
          api_key = ApiKey.find_by(access_token: http_auth_header)

          error!("Unauthorized", 401) unless api_key

          api_key.expire! unless api_key.expired?

          status 200
        end
      end
    end
  end
end
