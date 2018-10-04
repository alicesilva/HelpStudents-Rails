class Course < ApplicationRecord
  validates_presence_of :name, :description
  belongs_to :semester

  has_many :tasks, dependent: :destroy
  has_many :absences, dependent: :destroy
end
