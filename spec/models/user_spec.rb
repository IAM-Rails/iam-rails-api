# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe 'asociations' do
    it { is_expected.to have_many(:api_keys) }
  end

  describe 'access_token' do
    subject { user.api_key }

    let(:user) { create(:user, :with_api_key) }
    let(:result) { user.api_keys.last }

    it 'returns expected structure' do
      is_expected.to eq(result)
    end

    it 'returns ApiKey' do
      is_expected.to be_a(ApiKey)
    end
  end

  describe 'access_token' do
    subject { user.access_token }

    let(:user) { create(:user, :with_api_key) }
    let(:result) { user.api_keys.last.access_token }

    it 'returns expected structure' do
      is_expected.to eq(result)
    end

    it 'returns String' do
      is_expected.to be_a(String)
    end
  end
end
