#:nodoc:
class Api::V1::CourseSerializer < ActiveModel::Serializer
  attributes :name, :description, :grades, :absences_allowed, :absences_committed,
             :semester_id, :created_at, :updated_at
end