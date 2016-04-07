class StripeEvent < ApplicationRecord

  validates_presence_of :stripe_id, :body

  def mark_processed!
    update_attributes!(processed_at: Time.zone.now)
  end
end
