FactoryBot.define do
  factory :semester do
    name { Faker::Number.between(1970, 2017).to_s + '.' + Faker::Number.between(1, 2).to_s }
    user
  end
end
