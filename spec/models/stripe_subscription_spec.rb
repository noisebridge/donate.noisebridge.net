require 'rails_helper'

describe StripeSubscription, type: :model do
  let(:stripe_customer) { double(id: "stripe-1") }
  let(:donor) { create(:donor) }
  let(:plan) { create(:stripe_plan, amount: 10_00) }

  before do
    allow(Stripe::Customer).to receive(:create).and_return(stripe_customer)
    allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
    allow(Stripe::Plan).to receive(:retrieve).and_return(true)
  end

  it { is_expected.to validate_presence_of(:donor) }
  it { is_expected.to validate_presence_of(:plan) }

  it { is_expected.to belong_to(:donor) }

  it 'creates a Stripe::Subscription when creating' do
    sub_double = double(id: 1)
    expect(stripe_customer).to receive_message_chain(:subscriptions, :create).with(plan: plan.stripe_id).and_return(sub_double)

    subject.class.create(donor: donor, plan: plan)
  end
end
