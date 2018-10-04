# Represent a system user.
# Composed by name, email, password, cell phone number and cut note (minimum score).
# Need to authenticate yourself, use tasks, semesters, courses and pomodoros.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :cell_phone, :minimun_score
  validates_uniqueness_of :auth_token
  before_create :generate_authentication_token!

  has_many :semesters, dependent: :destroy

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while User.exists?(auth_token: auth_token)
  end
end