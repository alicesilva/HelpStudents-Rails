require 'rails_helper'

RSpec.describe 'Semesters API', type: :request do
  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /api/v1/semesters' do
    before do
      create_list(:semester, 5, user_id: user.id)
      get '/api/v1/semesters', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns 5 semesters from database' do
      expect(json_body[:data].count).to eq(5)
    end
  end

  describe 'GET /api/v1/semesters/:id' do
    let(:semester) { create(:semester, user_id: user.id) }

    before { get "/api/v1/semesters/#{semester.id}", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns json for semester' do
      expect(json_body[:data][:attributes][:name]).to eq(semester.name)
    end
  end

  describe 'POST /api/v1/semesters' do
    let(:semester_params) { attributes_for(:semester) }

    before do
      post '/api/v1/semesters', params: { semester: semester_params }.to_json, headers: headers
    end

    context 'when params are valid' do

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'saves semester in database' do
        expect( Semester.find_by(name: semester_params[:name]) ).not_to be_nil
      end

      it 'returns json for created semester' do
        expect(json_body[:data][:attributes][:name]).to eq(semester_params[:name])
      end

      it 'assigns the created semester to the current user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end
    end

    context 'when params are invalid' do
      let(:semester_params) { attributes_for(:semester, name: ' ') }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'doesn\'t saves semester in the database' do
        expect( Semester.find_by(name: semester_params[:name]) ).to be_nil
      end

      it 'returns json error for name' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'PUT /api/v1/semesters/:id' do
    let(:semester) { create(:semester, user_id: user.id) }

    before do
      put "/api/v1/semesters/#{semester.id}", params: { semester: semester_params }.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:semester_params) { { name: '3001.2' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns json for updated semester' do
        expect(json_body[:data][:attributes][:name]).to eq(semester_params[:name])
      end

      it 'updates semester in the database' do
        expect( Semester.find_by(name: semester_params[:name]) ).not_to be_nil
      end
    end

    context 'when params are invalid' do
      let(:semester_params) { { name: ' ' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns json error for name' do
        expect(json_body[:errors]).to have_key(:name)
      end

      it 'doesn\'t updates semester in database' do
        expect( Semester.find_by(name: semester_params[:name]) ).to be_nil
      end
    end
  end

  describe 'DELETE /api/v1/semesters/:id' do
    let(:semester) { create(:semester, user_id: user.id) }

    before do
      delete "/api/v1/semesters/#{semester.id}", params: {}, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes semester from database' do
      expect { Semester.find(semester.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end