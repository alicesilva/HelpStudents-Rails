# Absence microservices for show infos, create new absence and delete
# existing absences.
class Api::V1::AbsencesController < Api::V1::BaseController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    absences = current_user.semesters.find_by(id: params[:semester_id]).courses.find_by(id: params[:course_id]).absences
    render json: absences, status: :ok
  end

  def show
    absences = current_user.semesters.find_by(id: params[:semester_id]).courses.find_by(id: params[:course_id]).absences
    absence = absences.find_by(id: params[:id])
    render json: absence, status: :ok
  end

  def create
    absences = current_user.semesters.find_by(id: params[:semester_id]).courses.find_by(id: params[:course_id]).absences
    absence = absences.build(absence_params)
    if absence.save
      render json: absence, status: :created
    else
      render json: { errors: absence.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    absences = current_user.semesters.find_by(id: params[:semester_id]).courses.find_by(id: params[:course_id]).absences
    absence = absences.find_by(id: params[:id])
    if absence.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private

  def absence_params
    params.require(:absence).permit(:time, :reason)
  end
end
