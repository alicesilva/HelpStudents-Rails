# Represent task (term).
class Task < ApplicationRecord
  belongs_to :course
  validates_presence_of :name
  validates_presence_of :start
  validates_presence_of :close
end
