# Task microservices for show infos, create new task, update and delete
# existing task.
class Api::V1::TasksController < Api::V1::BaseController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    tasks = current_user.semesters.find_by(id: params[:semester_id]).courses.find_by(id: params[:course_id]).tasks
    render json: tasks, status: :ok
  end

  def show
    courses = current_user.semesters.find_by(id: params[:semester_id]).courses
    tasks = courses.find_by(id: params[:course_id]).tasks
    task = tasks.find_by(id: params[:id])
    render json: task, status: :ok
  end

  def create
    courses = current_user.semesters.find_by(id: params[:semester_id]).courses
    tasks = courses.find_by(id: params[:course_id]).tasks
    task = tasks.build(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  def update
    courses = current_user.semesters.find_by(id: params[:semester_id]).courses
    tasks = courses.find_by(id: params[:course_id]).tasks
    task = tasks.find_by(id: params[:id])
    if task.update_attributes(task_params)
      render json: task, status: :ok
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    tasks = current_user.semesters.find_by(id: params[:semester_id]).courses.find_by(id: params[:course_id]).tasks
    task = tasks.find_by(id: params[:id])
    if task.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :start, :close)
  end
end
