require 'rails_helper'

describe StripeDonationsController, type: :controller do
  let(:stripe_token) { "tok_12345" }
  let(:amount) { 10_00 }
  let(:email) { "treasurer@noisebridge.net" }

  before do
    allow(Stripe::Customer).to receive(:create)
    allow(Stripe::Plan).to receive(:create)
  end

  it 'creates a StripePlan, Donor and StripeSusbcription' do
    expect(Stripe
  end
end
