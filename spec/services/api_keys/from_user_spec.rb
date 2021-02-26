# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKeys::FromUser do
  subject { described_class.call(user_id: user.id) }

  let(:user) { create(:user) }

  context 'when API Key does not exist' do
    it 'returns a new API Key' do
      expect { subject }.to change(ApiKey, :count).by(1)
    end

    it 'contains user linked' do
      expect(subject.user).to eq(user)
    end
  end
end
