# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth API V1' do
  let(:base_url) { '/v1/auth' }

  let(:error_type) do
    {
      error: :string
    }
  end

  describe 'POST v1/auth/register' do
    let(:user_type) do
      {
        id: :integer,
        email: :string,
        name: :string
      }
    end
    let(:params) do
      {
        email: 'pepe@gmail.com',
        password: 'supersecretpassword',
        name: 'Pepe',
      }
    end

    before { post "#{base_url}/register", params: params }

    it 'returns 201 OK' do
      expect_status(201)
    end

    it 'returns correct types' do
      expect_json_types(user_type)
    end

    it 'returns correct values' do
      expect_json(name: params[:name], email: params[:email])
    end

    it 'reigsters an inactive user' do
      expect(User.find_by(email: params[:email]).is_active?).to be_falsey
    end
  end

  describe 'POST v1/auth/login' do
    let!(:user) { create(:user, :with_api_key) }
    let(:login_type) do
      {
        id: :integer,
        created_at: :string,
        updated_at: :string,
        email: :string,
        name: :string,
        access_token: :string
      }
    end
    let(:params) do
      {
        email: user.email,
        password: user.password
      }
    end

    before { post "#{base_url}/login", params: params }

    it 'returns 201 OK' do
      expect_status(201)
    end

    it 'returns correct types' do
      expect_json_types(login_type)
    end

    it 'returns correct values' do
      expect_json(id: user.id)
    end
  end

  describe 'POST v1/auth/logout' do
    let(:api_key) { create(:api_key) }
    let(:headers) { { 'Authorization' => api_key.access_token } }

    before { post "#{base_url}/logout", headers: headers }

    it 'returns 200 OK' do
      expect_status(200)
    end

    it 'expires api key' do
      api_key.reload
      expect(api_key.expired?).to be_truthy
    end
  end

  describe 'Post v1/auth/login with wrong password' do
    let!(:user) { create(:user, :with_api_key) }
    let(:wrong_password) do
      {
        email: user.email,
        password: 'wrongpassword'
      }
    end

    before { post "#{base_url}/login", params: wrong_password }

    it 'returns 403' do
      expect_status(403)
    end

    it 'returns correct types' do
      expect_json_types(error_type)
    end
  end

  describe 'Post v1/auth/login with wrong user' do
    let!(:user) { create(:user, :with_api_key) }
    let(:wrong_user) do
      {
        email: 'cuco@gmail.com',
        password: user.password
      }
    end

    before { post "#{base_url}/login", params: wrong_user }

    it 'returns 403' do
      expect_status(403)
    end

    it 'returns correct types' do
      expect_json_types(error_type)
    end
  end

  shared_examples 'contains auth token' do
    before { post base_url, params: user_params }

    it('contains string auth token') { expect_json_types(auth_token: :string) }
    it('return status correct code') { expect_status(expected_status_code) }
  end

  shared_examples 'invalid credentials' do
    before { post base_url, params: user_params }

    it('contains string auth token') do
      expect_json_types('error', { user_authentication: :string })
    end

    it('return status correct code') { expect_status(expected_status_code) }
  end

  describe 'GET /authenticate' do
    let(:users) { create_list(:user, 2) }
    let(:base_url) { '/authenticate' }
    let(:expected_status_code) { 200 }

    let(:user_params) do
      {
        email: users.first.email,
        password: users.first.password,
        phone_number: users.first.phone_number
      }
    end

    it_behaves_like 'contains auth token'
  end

  describe 'GET /authenticate with invalid credentials' do
    let(:users) { create_list(:user, 2) }
    let(:base_url) { '/authenticate' }
    let(:expected_status_code) { 401 }

    let(:user_params) do
      {
        email: users.first.email,
        password: 'wrong password',
        phone_number: users.first.phone_number
      }
    end

    it_behaves_like 'invalid credentials'
  end
end
