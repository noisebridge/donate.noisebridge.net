require 'rails_helper'

describe SubscriptionsController, type: :controller do
  let(:stripe_token) { "tok_12345" }
  let(:amount) { 10 }
  let(:email) { "treasurer@noisebridge.net" }

  let(:stripe_customer) { double(id: 'customer-1') }

  before do
    allow(Stripe::Customer).to receive(:create).and_return(stripe_customer)
    allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
    allow(Stripe::Plan).to receive(:create)
  end

  context 'with an existing StripePlan' do
    let(:plan) { create(:stripe_plan, amount: 10_00) }

    it 'creates a Donor and StripeSubscription' do
      expect(Donor).to receive(:new).with(
        email: email,
        stripe_token: stripe_token
      ).and_call_original

      allow(stripe_customer).to receive_message_chain(:subscriptions, :create).with(
        plan: plan.stripe_id
      ).and_return(double(id: 'subscription-1'))

      post :create, donor: {email: email, stripe_token: stripe_token}, plan: {amount: 10}, subscription: {dues: false}, format: :json
    end
  end
end
