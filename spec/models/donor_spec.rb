require 'rails_helper'

describe Donor, type: :model do
  let(:stripe_token) { 'tok_1234' }

  let(:email) { 'treasurer@noisebridge.net' }
  let(:password) { "a" * 8 }

  it { is_expected.to validate_presence_of(:email) }

  context 'creating Stripe::Customer objects' do
    it 'creates when no stripe_customer_id is set' do
      expect(Stripe::Customer).to receive(:create).once.with(
        email: email,
        card: stripe_token
      ).and_return(double(id: "stripe_customer_1"))
      Donor.create!(email: email, stripe_token: stripe_token, password: password, password_confirmation: password)
    end

    it 'does not create when stripe_customer_id is set' do
      expect(Stripe::Customer).to_not receive(:create)
      Donor.create!(email: email, stripe_customer_id: 'not-exist', password: password, password_confirmation: password)
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

end
