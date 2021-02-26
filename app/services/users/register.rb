# frozen_string_literal: true

module Users
  # The Register service is responsive for perform users registration
  class Register
    attr_reader :params

    def initialize(params:)
      @params = params
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      user = create_user
      ApiKeys::FromUser.call(user_id: user_id)
      user
    end

    private

    def create_user
      User.create!(params)
    end
  end
end
