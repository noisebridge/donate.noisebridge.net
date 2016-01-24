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
      expect(Stripe::Charge).to receive(:create) do |opts|
        expect(opts[:amount]).to eq(charge.amount)
        expect(opts[:currency]).to eq('usd')
        expect(opts[:customer]).to eq(donor.stripe_customer_id.to_i)
        stripe_charge
      end

      expect {
        charge.save!
      }.to change { charge.stripe_charge_id }
    end

    it "returns a validation error if the Stripe::Charge fails" do
      expect(charge.stripe_charge_id).to be_blank
      expect(Stripe::Charge).to receive(:create).once.and_raise(Stripe::CardError.new("Declined", :token, 422))
      expect(charge.save).to be_falsey
      expect(charge.errors[:card]).to include("Declined")
    end

    it 'does not create a Stripe::Charge object if the stripe_charge_id is set already' do
      charge.stripe_charge_id = 'forced'
      expect(Stripe::Charge).to_not receive(:create)
      charge.save!
    end
  end

  context "project_totals" do
    before do
      allow(Stripe::Charge).to receive(:create).and_return(stripe_charge)
      allow(stripe_charge).to receive(:id).and_return(*1..10)
    end

    let(:stripe_charge) { double }
    let!(:charge_1) { create(:charge, amount: 100_00, tag: "project-1") }
    let!(:charge_2) { create(:charge, amount: 200_00, tag: "project-1") }
    let!(:charge_3) { create(:charge, amount: 200_00, tag: "project-2") }
    let!(:charge_4) { create(:charge, amount: 200_00, tag: nil) } 

    it "sums the Charge totals grouped by tag" do
      totals = Charge.project_totals
      expect(totals["project-1"]).to eq(charge_1.amount + charge_2.amount)
      expect(totals["project-2"]).to eq(charge_3.amount)
      expect(totals.keys).to match_array(["project-1", "project-2"])
    end
  end
end
