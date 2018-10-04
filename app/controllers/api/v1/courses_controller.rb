# Course microservices for show infos, create new course, update and delete
# existing course.
class Api::V1::CoursesController < Api::V1::BaseController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    courses = current_user.semesters.find_by(id: params[:semester_id]).courses
    render json: courses, status: :ok
  end

  def show
    courses = current_user.semesters.find_by(id: params[:semester_id]).courses
    course = courses.find_by(id: params[:id])
    render json: course, status: :ok
  end
end
