require 'rails_helper'

RSpec.describe 'User Registrations', type: :request do
  describe 'POST /users' do
    let(:valid_attributes) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          name: "Jhon"
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          email: 'invalid_email',
          password: 'short',
          password_confirmation: 'different_password',
          name: ""
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user and returns a success response' do
        expect {
          post '/users', params: valid_attributes, headers: { 'ACCEPT' => 'application/json' }
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Signed up successfully.')
        expect(json_response['data']).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user and returns an error response' do
        expect {
          post '/users', params: invalid_attributes, headers: { 'ACCEPT' => 'application/json' }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response['status']['message']).to include("User couldn't be created successfully.")
      end
    end
  end
end
