class Donor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :charges, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  before_create :create_stripe_customer

  validates_presence_of(:email, allow_blank?: false)

  attr_accessor :stripe_token

  def self.generate_password
    SecureRandom.hex(8)
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(self.stripe_customer_id)
  end

  def create_payment_source(token)
    card = stripe_customer.sources.create(source: token)
    stripe_customer.default_source = card.id
    stripe_customer.save
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

