# frozen_string_literal: true

module ApiKeys
  class FromUser
    attr_reader :user_id

    def initialize(user_id:)
      @user_id = user_id
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      ApiKey.create!(user_id: user_id)
    end

    private

    def api_key
      @api_key ||= ApiKey.find_by(user_id: user_id)
    end
  end
end
