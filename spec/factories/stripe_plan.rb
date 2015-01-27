FactoryGirl.define do
  factory :stripe_plan do
    integer :amount
    string :name
    string :stripe_id
  end
end
