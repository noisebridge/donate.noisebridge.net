class Plan < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  self.table_name = 'stripe_plans'

  validates_presence_of :amount

  before_create :set_name
  before_create :generate_stripe_id
  before_create :create_stripe_plan

  def stripe_plan
    Stripe::Plan.retrieve(stripe_id)
  end

  private

  def set_name
    self.name = "#{number_to_currency(amount / 100, precision: 0)} / month"
  end

  def generate_stripe_id
    self.stripe_id = "noisebridge_donation_#{amount / 100}"
  end

  def create_stripe_plan
    return if Stripe::Plan.retrieve(stripe_id).present?
    Stripe::Plan.create(
      id: stripe_id,
      name: name,
      amount: amount,
      currency: 'usd',
      interval: 'month',
      statement_descriptor: "Noisebridge donation"
    )
  rescue
    false
  end
end
