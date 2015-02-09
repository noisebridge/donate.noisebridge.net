require 'rails_helper'

describe Donor, type: :model do
  let(:stripe_token) { 'tok_1234' }

  let(:email) { 'treasurer@noisebridge.net' }

  it 'creates Stripe::Customer objects on creation' do
    expect(Stripe::Customer).to receive(:create).once.with(
      email: email,
      card: stripe_token
    ).and_return(double(id: "stripe_customer_1"))
    Donor.create!(email: email, stripe_token: stripe_token)
  end

  context "#name" do
    let(:anonymous) { create(:donor, anonymous: true, name: "Torrie Fischer") }
    let(:mitch) { create(:donor, name: "Mitch Altman") }

    it "is Anonymous when anonymous: true" do
      expect(anonymous.name).to eq("Anonymous")
    end

    it "is their name when anonymous: false" do
      expect(mitch.name).to eq("Mitch Altman")
    end
  end

end
