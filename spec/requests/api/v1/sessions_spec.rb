require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  let(:user) { create(:user) }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'POST /api/v1/users/sign_in' do
    before do
      post '/api/v1/users/sign_in', params: { session: credentials }.to_json, headers: headers
    end

    context 'when credentials are correct' do
      let(:credentials) { { email: user.email, password: '123456'} }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns json data for user with auth token' do
        user.reload
        expect(json_body[:data][:attributes][:'auth-token']).to eq(user.auth_token)
      end
    end

    context 'when credentials are incorrect' do
      let(:credentials) { { email: user.email, password: 'invalid'} }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns json data for errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /api/v1/users/sign_out' do
    let(:auth_token) { user.auth_token }

    before do
      delete "/api/v1/users/sign_out", params: { session: { auth_token: user.auth_token } }.to_json, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'changes user auth token' do
      expect( User.find_by(auth_token: auth_token) ).to be_nil
    end
  end
end
