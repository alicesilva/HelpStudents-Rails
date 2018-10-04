FactoryBot.define do
	factory :absence do
		reason { Faker::Lorem.paragraph }
		time { Faker::Date.forward(0)}
		course
	end
end
