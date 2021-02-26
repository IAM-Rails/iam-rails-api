# frozen_string_literal: true

module V1
  module Entities
    class ApiKey < Base
      expose :id
      expose :access_token
      expose :expires_at
      expose :user_id
      expose :created_at
      expose :updated_at
    end
  end
end
