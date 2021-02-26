# frozen_string_literal: true

module VersionOne
  module Entities
    # The TokenUser class inherits from User and expose its api token
    class TokenUser < User
      expose :api_token
    end
  end
end
