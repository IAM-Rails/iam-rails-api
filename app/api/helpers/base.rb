# frozen_string_literal: true

module Helpers
  module Base
    def permitted_params
      @permitted_params ||= declared(params, include_missing: false)
    end

    def logger
      Rails.logger
    end

    def authenticate!
      error!('Invalid or expired token.', 401) unless current_user
    end

    def current_user
      @current_user ||= begin
        error!('Missing authorization header.', 401) unless http_auth_header

        token = ApiKey.find_by(access_token: http_auth_header)
        error!('Invalid token.', 401) unless token

        current_user_from_token(token)
      end
    end

    def current_user_from_token(token)
      error!('Expired token') if token.expired?

      @current_user = ::User.find(token.user_id)
    end

    def http_auth_header
      headers['Authorization'] || params['api_key']
    end
  end
end
