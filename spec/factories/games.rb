FactoryBot.define do
  factory :game do
  	sequence(:opponent) { |n| "opponent#{n}" }
  	date do
	    from = Time.now.to_f
	    to   = 2.years.from_now.to_f
	    Time.at(from + rand * (to - from))
	end
	team
  end
end
