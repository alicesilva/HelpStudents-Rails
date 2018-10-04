# Represent semester (term).
# Composed by name of semester.
# Need to validates name of semester.
class Semester < ApplicationRecord
  validates_presence_of :name
  has_many :courses, dependent: :destroy
  belongs_to :user
end
