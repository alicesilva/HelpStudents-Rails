require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  let!(:user) { create(:user) }
  let!(:semester) { create(:semester, user_id: user.id) }
  let!(:course) { create(:course, semester_id: semester.id) }
  let(:headers) do
      {
        'Content-Type' => Mime[:json].to_s,
        'Authorization' => user.auth_token
      }
  end

  describe 'GET /api/v1/semesters/:semester_id/courses/:course_id/tasks' do
    before do
      create_list(:task, 5, course_id: course.id)
        get "/api/v1/semesters/#{semester.id}/courses/#{course.id}/tasks", params: {}, headers: headers
      end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
    
    it 'returns 5 tasks from database' do
      expect(json_body.length).to eq(5)
    end
  end

  describe 'GET /api/v1/semesters/:semester_id/courses/:course_id/tasks/:id' do
    let(:task_id) { task.id }
    let(:task) { create(:task, course_id: course.id) }

    before { get "/api/v1/semesters/#{semester.id}/courses/#{course.id}/tasks/#{task.id}", params: {}, headers: headers}
    
    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
    
    it 'returns json for task' do
      expect(json_body[:name]).to eq(task.name)
    end
  end

  describe 'POST /api/v1/semesters/:semester_id/courses/:course_id/tasks' do
    let(:task_params) { attributes_for(:task) }
    
    before { post "/api/v1/semesters/#{semester.id}/courses/#{course.id}/tasks", params: { task: task_params }.to_json, headers: headers}
    
    context 'when params are valid' do
      
      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end
      
      it 'saves task in database' do
        expect( Task.find_by(name: task_params[:name]) ).not_to be_nil
      end
      
      it 'returns json for created task' do
        expect(json_body[:name]).to eq(task_params[:name])
      end
      
      it 'assigns the created task to the current course' do
        expect(json_body[:course_id]).to eq(course.id)
      end
    end
    
    context 'when params are invalid' do
      let(:task_params) { attributes_for(:task, name: ' ') }
      
      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it 'does not saves task in database' do
        expect( Task.find_by(name: task_params[:name]) ).to be_nil
      end
      
      it 'returns the json error for name' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'PUT /api/v1/semesters/:semester_id/courses/:course_id/tasks/:id' do
    let(:task) { create(:task, course_id: course.id) }

    before do
      put "/api/v1/semesters/#{semester.id}/courses/#{course.id}/tasks/#{task.id}", params: { task: task_params }.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:task_params) { { name: 'Atividade' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns json for updated task' do
        expect(json_body[:name]).to eq(task_params[:name])
      end

      it 'updates task in the database' do
        expect( Task.find_by(name: task_params[:name]) ).not_to be_nil
      end
    end

    context 'when params are invalid' do
      let(:task_params) { { name: ' ' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns json error for name' do
        expect(json_body[:errors]).to have_key(:name)
      end

      it 'doesn\'t updates task in database' do
        expect( Task.find_by(name: task_params[:name]) ).to be_nil
      end
    end
  end

  describe 'DELETE /api/v1/semesters/:semester_id/courses/:course_id/tasks/:id' do
    let(:task) { create(:task, course_id: course.id) }

    before do
      delete "/api/v1/semesters/#{semester.id}/courses/#{course.id}/tasks/#{task.id}", params: {}, headers: headers
    end
    
    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes semester from database' do
      expect{ Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end