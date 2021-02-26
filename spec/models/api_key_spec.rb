# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  let!(:api_key) { create(:api_key) }

  describe 'validations' do
    it { is_expected.to belong_to :user }
  end

  describe '#expired?' do
    subject { api_key.expired? }

    it 'returns false' do
      is_expected.to be false
    end
  end

  describe '#expire!' do
    it 'returns true' do
      expect {
        api_key.expire!
      }.to change(api_key, :expires_at)
    end
  end
end
