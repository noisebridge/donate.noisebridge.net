class Donor < ActiveRecord::Base

  has_many :charges
  has_many :subscriptions

  before_create :create_stripe_customer

  attr_accessor :stripe_token

  def stripe_customer
    Stripe::Customer.retrieve(self.stripe_customer_id)
  end

  def name
    anonymous? ? "Anonymous" : super
  end

  private

  def create_stripe_customer
    self.stripe_customer_id = Stripe::Customer.create(
        email: self.email,
        card: self.stripe_token
    ).id
  end
end

