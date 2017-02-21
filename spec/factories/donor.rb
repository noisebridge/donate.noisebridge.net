FactoryGirl.define do
  factory :donor do
    sequence(:email) { |n| "donor-#{n}@example.org" }
  end
end
