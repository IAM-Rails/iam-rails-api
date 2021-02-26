# frozen_string_literal: true

class ApiKey < ApplicationRecord
  before_validation :generate_access_token, :set_expiration, on: :create

  belongs_to :user
  validates :user_id, presence: true
  validates :access_token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  def expired?
    Time.now >= expires_at
  end

  def expire!(at: Time.now)
    update!(expires_at: at)
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def set_expiration
    self.expires_at = 7.days.from_now
  end
end
