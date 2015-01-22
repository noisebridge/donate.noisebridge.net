class StripePlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  validates_presence_of :amount, :name

  before_create :generate_stripe_id
  before_create :create_stripe_plan

  def stripe_plan
    Stripe::Plan.retrieve(self.stripe_id)
  end

  private

  def generate_stripe_id
    self.stripe_id = "noisebridge_donation_#{amount/100}"
  end

  def create_stripe_plan
    Stripe::Plan.create(
      id: self.stripe_id,
      name: "#{number_to_currency(amount / 100, precision: 0)} / month",
      amount: amount,
      currency: 'usd',
      interval: 'month',
      statement_descriptor: "Noisebridge donation"
    )
  end
end
