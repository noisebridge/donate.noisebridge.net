class Donor < ActiveRecord::Base

  has_many :charges, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  before_create :create_stripe_customer

  validates_presence_of(:email, allow_blank?: false)

  attr_accessor :stripe_token

  def stripe_customer
    Stripe::Customer.retrieve(self.stripe_customer_id)
  end

  def create_payment_source(token)
    stripe_customer.sources.create(source: token)
  end

  def name
    if anonymous?
      "Anonymous"
    elsif super.blank?
      email
    else
      super
    end
  end

  private

  def create_stripe_customer
    return if self.stripe_customer_id.present?
    self.stripe_customer_id = Stripe::Customer.create(
        email: self.email,
    ).id
  rescue Stripe::InvalidRequestError => e
    errors.add('stripe_token', e.message)
  end
end

