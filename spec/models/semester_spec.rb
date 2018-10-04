require 'rails_helper'

RSpec.describe Semester, type: :model do
  let(:semester) { build(:semester) }

  it { is_expected.to have_many(:courses) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it 'validates format aaaa.1 or aaaa.2'
end
