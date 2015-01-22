require 'rails_helper'

describe StripePlan, type: :model do
  before do
    allow(Stripe::Plan).to receive(:create)
  end

  it 'generates a stripe_id on create' do
    plan = StripePlan.new(
      amount: 10_00,
      name: "$10/month"
    )
    expect(plan.stripe_id).to be_blank
    plan.save
    expect(plan.stripe_id).to_not be_blank
  end

  it 'creates a plan in Stripe on create'
end

