# frozen_string_literal: true

module V1
  module Entities
    class TokenUser < User
      expose :api_token
    end
  end
end
