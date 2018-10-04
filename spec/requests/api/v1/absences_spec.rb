require 'rails_helper'

RSpec.describe 'Absences API', type: :request do
  let!(:user) { create(:user) }
  let!(:semester) { create(:semester, user_id: user.id) }
  let!(:course) { create(:course, semester_id: semester.id) }
  let(:headers) do
      {
        'Content-Type' => Mime[:json].to_s,
        'Authorization' => user.auth_token
      }
  end

  describe 'GET /api/v1/semesters/:semester_id/courses/:course_id/absences' do
    before do
      create_list(:absence, 5, course_id: course.id)
        get "/api/v1/semesters/#{semester.id}/courses/#{course.id}/absences", params: {}, headers: headers
      end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
    
    it 'returns 5 absence from database' do
      expect(json_body.length).to eq(5)
    end
  end

  describe 'GET /api/v1/semesters/:semester_id/courses/:course_id/absences/:id' do
    let(:absence_id) { absence.id }
    let(:absence) { create(:absence, course_id: course.id) }

    before { get "/api/v1/semesters/#{semester.id}/courses/#{course.id}/absences/#{absence.id}", params: {}, headers: headers}
    
    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
    
    it 'returns json for absence' do
      expect(json_body[:time] == absence.time)
    end
  end

  describe 'POST /api/v1/semesters/:semester_id/courses/:course_id/absences' do
    let(:absence_params) { attributes_for(:absence) }
    
    before { post "/api/v1/semesters/#{semester.id}/courses/#{course.id}/absences", params: { absence: absence_params }.to_json, headers: headers}
    
    context 'when params are valid' do
      
      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end
      
      it 'saves task in database' do
        expect( Absence.find_by(time: absence_params[:time]) ).not_to be_nil
      end
      
      it 'returns json for created absence' do
        expect(json_body[:time] == absence_params[:time])
      end
      
      it 'assigns the created task to the current course' do
        expect(json_body[:course_id]).to eq(course.id)
      end
    end
    
    context 'when params are invalid' do
      let(:absence_params) { attributes_for(:absence, time: nil) }
      
      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it 'does not saves absence in database' do
        expect( Absence.find_by(time: absence_params[:time]) ).to be_nil
      end
      
      it 'returns the json error for time' do
        expect(json_body[:errors]).to have_key(:time)
      end
    end
  end

  describe 'DELETE /api/v1/semesters/:semester_id/courses/:course_id/absences/:id' do
    let(:absence) { create(:absence, course_id: course.id) }

    before do
      delete "/api/v1/semesters/#{semester.id}/courses/#{course.id}/absences/#{absence.id}", params: {}, headers: headers
    end
    
    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes absence from database' do
      expect{ Absence.find(absence.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

