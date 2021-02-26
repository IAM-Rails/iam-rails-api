# frozen_string_literal: true

module V1
  module Entities
    class User < Base
      expose :id
      expose :email
      expose :name
      expose :created_at
      expose :updated_at

      with_options if: :with_access_token do
        expose :access_token
      end

      with_options if: :with_api_key do
        expose :api_key, with: Entities::ApiKey
      end
    end
  end
end
