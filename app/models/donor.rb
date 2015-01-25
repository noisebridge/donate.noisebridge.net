class Donor < ActiveRecord::Base

  has_many :donations
  has_many :subscriptions

  before_create :create_stripe_customer

  attr_accessor :stripe_token

  def stripe_customer
    Stripe::Customer.retrieve(self.stripe_customer_id)
  end

  private

  def create_stripe_customer
    customer = Stripe::Customer.create(
        email: self.email,
        card: self.stripe_token
    )
    self.stripe_customer_id = customer.id
  end
end

