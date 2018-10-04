require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { build(:course) }

  it { is_expected.to belong_to(:semester) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:tasks) }
  it { is_expected.to have_many(:absences) }

  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:grades) }
  it { is_expected.to respond_to(:absences_allowed) }
  it { is_expected.to respond_to(:absences_committed) }
  it 'set validation to considere pairs of elements \'weight\': \'grade\''
end
