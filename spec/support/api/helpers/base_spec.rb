# frozen_string_literal: true

RSpec.describe ::Helpers::Base do
  let(:target) do
    target_object = Object.new
    target_object.extend(described_class)
  end

  describe '#logger' do
    it 'returns Rails.logger' do
      expect(target.logger).to eq(Rails.logger)
    end
  end
end
