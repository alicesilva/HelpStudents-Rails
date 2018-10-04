require 'rails_helper'

RSpec.describe 'Courses API', type: :request do
  let!(:user) { create(:user) }
  let!(:semester) { create(:semester, user_id: user.id) }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /api/v1/semesters/:semester_id/courses' do
    before do
      create_list(:course, 5, semester_id: semester.id)
      get "/api/v1/semesters/#{semester.id}/courses", params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns 5 courses from database' do
      expect(json_body[:data].count).to eq(5)
    end
  end

  describe 'GET /api/v1/semesters/:semester_id/courses/:id' do
    let(:course_id) { course.id }
    let(:course) { create(:course, semester_id: semester.id) }

    before { get "/api/v1/semesters/#{semester.id}/courses/#{course_id}", params: {}, headers: headers }

    context 'when course exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns json for course' do
        expect(json_body[:data][:attributes][:name]).to eq(course.name)
      end
    end

    context 'when course don\'t exists' do
      let(:course_id) { 9999 }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns nil json for course' do
        expect(json_body).to be_nil
      end
    end
  end

  it 'POST /api/v1/semesters/:semester_id/courses'
  it 'PUT /api/v1/semesters/:semester_id/courses/:id'
  it 'DELETE /api/v1/semesters/:semester_id/courses/:id'
end