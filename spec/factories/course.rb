FactoryBot.define do
  factory :course do
    name { Faker::Educator.course }
    description { Faker::Lorem.sentence(3) }
    grades { [ [1, Faker::Number.decimal(1, 10)], [1, Faker::Number.decimal(1, 10)] ] }
    absences_allowed { Faker::Number.decimal(7, 10) }
    absences_committed { Faker::Number.decimal(1, 7) }
    semester
  end
end
