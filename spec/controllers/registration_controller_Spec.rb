require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { user: { email: 'test@example.com', password: 'password123' } } }

      it 'creates a new user' do
        expect {
          post :create, params: valid_params, format: :json
        }.to change(User, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: valid_params, format: :json
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct JSON structure' do
        post :create, params: valid_params, format: :json
        json_response = JSON.parse(response.body)

        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Signed up successfully.')
        expect(json_response['data']).to include('email' => 'test@example.com')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user: { email: 'invalid_email', password: 'short' } } }

      it 'does not create a new user' do
        expect {
          post :create, params: invalid_params, format: :json
        }.not_to change(User, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: invalid_params, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post :create, params: invalid_params, format: :json
        json_response = JSON.parse(response.body)

        expect(json_response['status']['message']).to include("User couldn't be created successfully")
        expect(json_response['status']['message']).to include("Email is invalid")
        expect(json_response['status']['message']).to include("Password is too short")
      end
    end
  end
end
