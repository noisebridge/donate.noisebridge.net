class Donor < ActiveRecord::Base

  has_many :charges, dependent: :destroy
  has_many :stripe_subscriptions, dependent: :destroy
  has_one :comment, dependent: :destroy

  before_create :create_stripe_customer

  validates_presence_of(:email, allow_blank?: false)
  validates_length_of(:comment, maximum: 200, message: "less than 200 characters please")

  attr_accessor :stripe_token

  def stripe_customer
    Stripe::Customer.retrieve(self.stripe_customer_id)
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
        card: self.stripe_token
    ).id
  end
end

