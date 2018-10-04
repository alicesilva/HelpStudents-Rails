require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /api/v1/users/:id, but using Authorization header, don\'t :id' do
    before do
      get '/api/v1/users/whatever', headers: headers
    end

    context 'when user exists' do
      it 'returns user' do
        expect(json_body[:data][:id].to_i).to eq(user_id)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user doesn\'t exists' do
      let(:headers) { { 'Content-Type' => Mime[:json].to_s, 'Authorization' => 'invalid' } }

      it 'returns status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/users' do
    before do
      post '/api/v1/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'when request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns json data for the created user' do
        expect(json_body[:data][:attributes][:email]).to eq(user_params[:email])
      end
    end

    context 'when request params are invalid' do
      let(:user_params) { { email: ' ' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns json error for email' do
        expect(json_body[:errors]).to have_key(:email)
      end

      it 'doesn\'t saves user in the database' do
        expect( User.find_by(email: user_params[:email]) ).to be_nil
      end
    end
  end

  describe 'PUT /api/v1/users/:id, but using Authorization header, don\'t :id' do
    before do
      put "/api/v1/users/whatever", params: { user: user_params }.to_json, headers: headers
    end

    context 'when request params are valid' do
      let(:user_params) { { email: 'example@helpstudents.com' } }

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns json data for updated user' do
        expect(json_body[:data][:attributes][:email]).to eq(user_params[:email])
      end
    end

    context 'when request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid_at_email.com') }

      it 'returns status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns json data for errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /api/v1/users/:id, but using Authorization header, don\'t :id' do
    before do
      delete "/api/v1/users/whatever", params: {}, headers: headers
    end

    it 'returns status 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes user from database' do
      expect( User.find_by(id: :user_id) ).to be_nil
    end
  end
end