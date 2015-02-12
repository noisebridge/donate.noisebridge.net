require 'rails_helper'

describe Charge, type: :model do
  let(:donor) { create(:donor) }

  it { is_expected.to belong_to(:donor) }

  context "validating positive charge amount" do
    let(:negative) { build(:charge, donor: donor, amount: -10_00) }
    let(:positive) { build(:charge, donor: donor, amount: 10_00) }

    it 'does not allow negative charge amounts' do
      expect(negative).to_not be_valid
      expect(positive).to be_valid
    end
  end

  context "creating Stripe::Charge" do
    let(:charge) { build(:charge, amount: 10_00, donor: donor) }
    let(:stripe_charge) { double(id: 1) }

    it "creates a Stripe::Charge on create" do
      expect(charge.stripe_charge_id).to be_blank
      expect(Stripe::Charge).to receive(:create).once.with(
        amount: charge.amount,
        currency: 'usd',
        customer: donor.stripe_customer_id
      ).and_return(stripe_charge)

      charge.save!
      expect(charge.reload.stripe_charge_id).to be_present
    end

    it "returns a validation error if the Stripe::Charge fails" do
      expect(charge.stripe_charge_id).to be_blank
      expect(Stripe::Charge).to receive(:create).once.and_raise(Stripe::CardError.new("Declined", :token, 422))
      expect(charge.save).to be_falsey
      expect(charge.errors[:card]).to include("Declined")
    end
  end
end
