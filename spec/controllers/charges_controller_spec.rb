require 'rails_helper'

describe ChargesController, type: :controller do
  let(:stripe_token) { "tok_12345" }
  let(:amount) { 10_00 }
  let(:email) { "treasurer@noisebridge.net" }

  let(:stripe_customer) { double(id: 'customer-1') }
  let(:stripe_charge) { double(id: 'charge-1') }
  let(:password) { "a" * 8 }

  before do
    allow(Stripe::Customer).to receive(:create).and_return(stripe_customer)
    allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
    allow(Donor).to receive(:generate_password).and_return(password)
  end

  context 'creating Charges' do
    before(:each) do
      expect(Stripe::Charge).to receive(:create)
        .once
        .with(amount: amount, currency: 'usd', customer: stripe_customer.id)
        .and_return(stripe_charge)
    end

    it 'creates a Donor and Charge' do
      expect(Donor).to receive(:new).with(
        email: email,
        stripe_token: stripe_token,
        password: password,
        password_confirmation: password
      ).and_call_original

      post :create,
        donor: {email: email, stripe_token: stripe_token},
        charge: {amount: 10},
        format: :json
      expect(assigns(:charge)).to be_persisted
    end

    it 'allows for anonymous donations' do
      expect(Donor).to receive(:new).with(
        email: email,
        stripe_token: stripe_token,
        anonymous: true,
        password: password,
        password_confirmation: password
      ).and_call_original

      post :create,
        donor: {email: email, stripe_token: stripe_token, anonymous: true},
        charge: {amount: 10},
        format: :json
      expect(assigns(:donor)).to be_anonymous
      expect(assigns(:charge)).to be_persisted
    end
  end

  context 'creating Subscriptions' do
    before do
      allow(Stripe::Plan).to receive(:create)
      allow_any_instance_of(Donor).to receive_message_chain(
        :stripe_customer,
        :subscriptions,
        :create
      ).and_return(stripe_subscription)
    end

    let(:plan) { Plan.create(amount: 10_00) }
    let(:stripe_subscription) { double(id: 'sub-1') }

    it 'creates subscriptions when charge[:recurring] is passed' do
      expect(Plan).to receive(:find_or_create_by!).with({
        amount: 10_00
      }).and_return(plan)

      post :create,
        donor: {email: email, stripe_token: stripe_token},
        charge: {amount: 10, recurring: 'on'},
        format: :json

      expect(assigns(:subscription)).to be_persisted
      expect(assigns(:subscription).plan).to eq(plan)
    end
  end
end

