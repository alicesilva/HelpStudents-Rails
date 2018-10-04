require 'rails_helper'

RSpec.describe Absence, type: :model do
  let(:absence) { build(:absence) }
  it { is_expected.to belong_to(:course)}
  it { is_expected.to validate_presence_of(:reason) }
  it { is_expected.to validate_presence_of(:time) }
  it { is_expected.to validate_presence_of(:course_id) }

  it { is_expected.to respond_to(:reason) }
  it { is_expected.to respond_to(:time) }
end
