class StripeSubscription < ActiveRecord::Base
  belongs_to(:donor)
  belongs_to(:plan)

  validates_presence_of(:donor)
  validates_presence_of(:plan)

  before_create(:create_stripe_subscription)

  private

  def create_stripe_subscription
    self.stripe_subscription_id = donor.subscriptions.create(
      plan: plan.stripe_id
    ).id
  end
end
