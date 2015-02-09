require 'rails_helper'

describe ChargesController, type: :controller do
  let(:stripe_token) { "tok_12345" }
  let(:amount) { 10_00 }
  let(:email) { "treasurer@noisebridge.net" }

  let(:stripe_customer) { double(id: 'customer-1') }
  let(:stripe_charge) { double(id: 'charge-1') }

  before do
    allow(Stripe::Customer).to receive(:create).and_return(stripe_customer)
    allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
  end

  it 'creates a Donor and Charge' do
    expect(Donor).to receive(:create!).with(
      email: email,
      stripe_token: stripe_token
    ).and_call_original

    expect(Stripe::Charge).to receive(:create)
      .once
      .with(amount: amount, currency: 'usd', customer: stripe_customer.id)
      .and_return(stripe_charge)

    post :create, donor: {email: email, stripe_token: stripe_token}, charge: {amount: 10_00}, format: :json
  end
end

