FactoryGirl.define do
  factory :stripe_event do
    sequence(:stripe_id) { |n|  "stripe-event-#{n}" }
    body JSON.generate(key: "value")
  end
end
