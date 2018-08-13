FactoryBot.define do
  factory :plan do
    amount 10_00
    name { "#{amount} / month" }
    stripe_id { "#{amount}_month" }
  end
end
