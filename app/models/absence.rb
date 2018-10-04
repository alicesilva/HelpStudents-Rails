class Absence < ApplicationRecord
  belongs_to :course
  validates_presence_of :reason
  validates_presence_of :time
  validates_presence_of :course_id
end
