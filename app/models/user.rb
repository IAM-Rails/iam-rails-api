# frozen_string_literal: true

class User < ApplicationRecord
  has_many :api_keys

  has_secure_password

  validates :name, presence: true, on: :create
  validates :email, uniqueness: true, on: :create
  validates :password, presence: true, on: :create

  attr_writer :new_password

  def api_key
    api_keys.last
  end

  def access_token
    api_key.access_token
  end
end
