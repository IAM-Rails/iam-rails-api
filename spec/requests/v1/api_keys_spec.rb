# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiKeys API V1' do
  let(:base_url) { '/v1/api_keys' }

  let(:headers) { { "Authorization" => api_key.access_token } }

  let!(:api_keys) { create_list(:api_key, 3) }
  let(:api_key) { create(:api_key) }
  let(:api_key_type) do
    {
      id: :integer,
      access_token: :string,
      expires_at: :string,
      user_id: :integer,
    }
  end

  describe 'GET /api_keys' do
    before do
      get base_url, headers: headers
    end

    it 'returns all api_keys' do
      expect_json_sizes(4)
    end

    it 'returns status code 200' do
      expect_status(200)
    end

    it 'returns right fields' do
      expect_json_types('*', api_key_type)
    end
  end

  describe 'GET /api_keys/:api_key_id' do
    let(:api_key) { api_keys.first }

    before do
      get "#{base_url}/#{api_key.id}", headers: headers
    end

    it 'returns status code 200' do
      expect_status(200)
    end

    it 'returns right fields' do
      expect_json_types(api_key_type)
    end

    context 'when wrong id provided' do
      before { get "#{base_url}/0", headers: headers }

      it 'returns error 404' do
        expect_status(404)
      end
    end
  end

  describe 'POST /api_keys' do
    let(:user) { create(:user) }
    let(:params) { Hash[user_id: user.id] }

    let(:api_key_response) do
      {
        id: :integer,
        created_at: :string,
        updated_at: :string,
        access_token: :string,
        expires_at: :string,
        user_id: :integer,
        active: :boolean_or_null
      }
    end

    before { post base_url, params: params, headers: headers }

    it 'returns status code 201' do
      expect_status(201)
    end

    it 'returns right fields' do
      expect_json_types(api_key_response)
    end
  end

  describe 'DELETE /api_keys/:api_key_id' do
    let!(:api_key) { create(:api_key) }

    it 'returns status code 204' do
      delete "#{base_url}/#{api_key.id}", headers: headers

      expect_status(204)
    end

    it 'destroys the record' do
      expect {
        delete "#{base_url}/#{api_key.id}", headers: headers
      }.to change(ApiKey, :count).by(-1)
    end
  end

  describe 'GET /api_key' do
    let!(:routing_error_url) { '/V1/api_key' }
    let!(:error_400_url) { '/v1/api_keys/foo' }

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
