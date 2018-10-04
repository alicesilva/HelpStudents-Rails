#:nodoc:
class Api::V1::SemesterSerializer < ActiveModel::Serializer
  attributes :name, :user_id, :created_at, :updated_at
end