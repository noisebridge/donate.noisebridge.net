class Charge < ApplicationRecord
  belongs_to(:donor)

  scope :tagged, -> { where("tag IS NOT NULL") }

  validates_presence_of(:amount)

  validate :positive_charge_amount

  before_create :create_stripe_charge

  def self.project_totals
    self.tagged.group(:tag).sum(:amount)
  end

  private

  def positive_charge_amount
    if amount <= 0
      errors.add(:amount, "must be positive")
    end
  end

  def create_stripe_charge
    return if self.stripe_charge_id.present?

    self.stripe_charge_id = Stripe::Charge.create(
      amount: self.amount,
      currency: 'usd',
      customer: donor.stripe_customer.id
    ).id
  rescue Stripe::CardError => exc
    errors.add(:card, exc.message)
    throw(:abort)
  end
end
