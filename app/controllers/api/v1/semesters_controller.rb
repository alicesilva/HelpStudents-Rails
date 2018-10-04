# Semester microservices for show infos, create new semester, update and delete
# existing semesters.
class Api::V1::SemestersController < Api::V1::BaseController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    semesters = current_user.semesters
    render json: semesters, status: :ok
  end

  def show
    semester = current_user.semesters.find_by(id: params[:id])
    render json: semester, status: :ok
  end

  def create
    semester = current_user.semesters.build(semester_params)
    if semester.save
      render json: semester, status: :created
    else
      render json: { errors: semester.errors }, status: :unprocessable_entity
    end
  end

  def update
    semester = current_user.semesters.find_by(id: params[:id])
    if semester.update_attributes(semester_params)
      render json: semester, status: :ok
    else
      render json: { errors: semester.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    semester = current_user.semesters.find_by(id: params[:id])
    if semester.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private

  def semester_params
    params.require(:semester).permit(:name)
  end
end
