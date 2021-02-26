# frozen_string_literal: true

module VersionOne
  module Entities
    # The ApiKeys entity is responsive for exposing model attrs
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
