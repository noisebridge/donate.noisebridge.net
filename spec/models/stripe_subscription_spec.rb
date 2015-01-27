require 'rails_helper'

describe StripeSubscription, type: :model do
  let(:stripe_customer) { double }
  let(:donor) { double(stripe_customer: stripe_customer) }
  let(:plan) { double(stripe_id: "plan-1") }

  it 'requires a donor'

  it 'requires a plan'

  it 'creates a Stripe::Subscription when creating' do
    sub_double = double(:id)
    expect(stripe_customer).to receive_message_chain(:subscriptions, :create).with(plan: plan.stripe_id).and_return(sub_double)

    subject.class.create(donor: donor, plan: plan)
  end
end
