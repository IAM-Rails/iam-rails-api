# frozen_string_literal: true

module Users
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
      register_keys(user.id)
      user
    end

    private

    def create_user
      params[:active] = false
      User.create!(params)
    end

    def register_keys(user_id)
      ApiKeys::FromUser.call(user_id: user_id)
    end
  end
end
