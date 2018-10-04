#:nodoc:
class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :auth_token, :name, :cell_phone, :minimun_score, 
             :created_at, :updated_at
end