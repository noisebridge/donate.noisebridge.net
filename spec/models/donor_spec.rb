require 'rails_helper'

describe Donor, type: :model do
  let(:stripe_token) { 'tok_1234' }

  let(:email) { 'treasurer@noisebridge.net' }

  it { is_expected.to validate_presence_of(:email) }

  context 'creating Stripe::Customer objects' do
    it 'creates when no stripe_customer_id is set' do
      expect(Stripe::Customer).to receive(:create).once.with(
        email: email,
      ).and_return(double(id: "stripe_customer_1"))
      Donor.create!(email: email, stripe_token: stripe_token)
    end

    it 'does not create when stripe_customer_id is set' do
      expect(Stripe::Customer).to_not receive(:create)
      Donor.create!(email: email, stripe_customer_id: 'not-exist')
    end
  end

  context "#name" do
    let(:anonymous) { create(:donor, anonymous: true, name: "Torrie Fischer") }
    let(:email_only) { create(:donor, anonymous: false) }
    let(:mitch) { create(:donor, name: "Mitch Altman") }

    it "is Anonymous when anonymous: true" do
      expect(anonymous.name).to eq("Anonymous")
    end

    it "is their email when Anonymous = false and name is blank" do
      expect(email_only.name).to eq(email_only.email)
    end

    it "is their name when anonymous: false" do
      expect(mitch.name).to eq("Mitch Altman")
    end
  end

  context "#first_name" do
    let(:anonymous) { create(:donor, anonymous: true, name: "Mitch Altman") }
    let(:mitch) { create(:donor, anonymous: false, name: "Mitch Altman") }

    it "is blank when anonymous" do
      expect(anonymous.first_name).to be_blank
    end

    it "returns first name" do
     expect(mitch.first_name).to eq("Mitch")
    end
  end

  context "#create_payment_source" do
    let(:donor) { create(:donor) }
    let(:token) { "token_123" }

    it "creates a new Stripe payment source" do
      customer = double(save: true, :"default_source=" => true)
      expect(Stripe::Customer).to receive(:retrieve).
        and_return(customer)
      expect(customer).to receive_message_chain(:sources, :create).
        with(source: token).
        and_return(double(id: "card-1"))
      donor.create_payment_source(token)
    end
  end

end
