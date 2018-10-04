require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { is_expected.to have_many(:semesters) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:cell_phone) }
  it { is_expected.to validate_presence_of(:minimun_score) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('example@email.com').for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#generate_authentication_token' do
    it 'generates a unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('asdf1234')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('asdf1234')
    end

    it 'generates a unique auth token when the current auth token already has been taken' do
      allow(Devise).to receive(:friendly_token).and_return('qwert09876', 'qwert09876', 'zxcv5678')
      existing_user = create(:user, auth_token: 'qwert09876')
      user.generate_authentication_token!

      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
  end
end
