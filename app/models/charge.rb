class Charge < ApplicationRecord
  belongs_to(:donor)

  scope :tagged, -> { where("tag IS NOT NULL") }

  validates_presence_of(:amount)

  validate :positive_charge_amount

  before_create :create_stripe_charge

  def self.project_totals
    tagged.group(:tag).sum(:amount)
  end

  private

  def positive_charge_amount
    errors.add(:amount, "must be positive") unless amount.positive?
  end

  def create_stripe_charge
    return if stripe_charge_id.present?

    self.stripe_charge_id = Stripe::Charge.create(
      amount: amount,
      currency: 'usd',
      customer: donor.stripe_customer.id
    ).id
  rescue Stripe::CardError => exc
    errors.add(:card, exc.message)
    throw(:abort)
  end
end
