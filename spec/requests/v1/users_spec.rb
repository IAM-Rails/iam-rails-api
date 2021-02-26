# frozen_string_literal: true

require 'rails_helper'
require 'ffaker'

RSpec.describe 'Users API V1' do
  let(:base_url) { '/v1/users' }

  let!(:user) { create(:user) }

  let(:api_key) { create(:api_key, user: user) }

  let(:headers) { { "Authorization" => api_key.access_token } }

  let(:user_type) do
    {
      id: :integer,
      name: :string,
      email: :string,
    }
  end

  describe 'GET /users' do
    before do
      get base_url, headers: headers
    end

    it 'returns total users' do
      expect_json_sizes(1)
    end

    it 'returns status code 200' do
      expect_status(200)
    end

    it 'returns right fields' do
      expect_json_types('*', user_type)
    end
  end

  describe 'GET /users/:user_id' do
    before do
      get "#{base_url}/#{user.id}", headers: headers
    end

    it 'returns status code 200' do
      expect_status(200)
    end

    it 'returns right fields' do
      expect_json_types(user_type)
    end

    context 'when wrong id provided' do
      before { get "#{base_url}/0", headers: headers }

      it 'returns error 403' do
        expect_status(403)
      end
    end
  end

  describe 'POST /users' do
    let(:params) { attributes_for(:user) }

    before { post base_url, headers: headers, params: params }

    it 'returns status code 201' do
      expect_status(201)
    end

    it 'returns right fields' do
      expect_json_types(user_type)
    end
  end

  describe 'PATCH /users/:user_id' do
    let(:params) do
      {
        name: FFaker::Name.name,
        email: FFaker::Internet.email,
        password: 'secret',
        password_confirmation: 'secret',
      }
    end
    let!(:user) { create(:user) }

    before { patch "#{base_url}/#{user.id}", headers: headers, params: params }

    it 'returns status code 200' do
      expect_status(200)
    end

    it 'returns right fields' do
      expect_json_types(user_type)
    end

    it 'returns right data' do
      expect_json(name: params[:name])
    end
  end

  describe 'GET /users' do
    let(:routing_error_url) { '/V1/user' }
    let(:error_400_url) { '/v1/users/foo' }

    it 'raises RoutingError' do
      expect {
        get routing_error_url, headers: headers
      }.to raise_error(ActionController::RoutingError)
    end

    it 'returns error 400' do
      get error_400_url, headers: headers

      expect_status(400)
    end
  end
end
