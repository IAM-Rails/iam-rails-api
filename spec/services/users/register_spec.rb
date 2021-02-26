# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Register do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      email: 'pepep@gmail.com',
      name: 'pepe',
      password: 'supersecretpassword',
    }
  end

  it 'returns a user' do
    is_expected.to be_a(User)
  end

  it 'contains email and name' do
    is_expected.to have_attributes(email: 'pepep@gmail.com',
                                   name: 'pepe')
  end
end
