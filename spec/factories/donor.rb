FactoryGirl.define do
  factory :donor do
    sequence(:email) {|n| "donor-#{n}@example.org" }
    password "testing-password"
    password_confirmation "testing-password"
  end
end
