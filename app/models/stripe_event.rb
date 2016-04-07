class StripeEvent < ApplicationRecord

  CHARGE_SUCCEEDED = "charge.succeeded".freeze

  validates_presence_of :stripe_id, :body

  def self.record_and_process(stripe_event)
    create!(
      body: stripe_event.as_json,
      stripe_id: stripe_event.id
    )
  end

  def process
    if should_email_receipt?
      queue_email_receipt_mail
    end
  end

  def type
    body['type']
  end

  def remote_created_at
    Time.at(body['created'])
  end

  def mark_processed!
    update_attributes!(processed_at: Time.zone.now)
  end

  private def should_email_receipt?
    type == CHARGE_SUCCEEDED
  end

  private def customer_id
    body['data']['object']['customer']
  end

  private def queue_email_receipt_mail
    email = Donor.find_by(stripe_customer_id: customer_id).email
    amount = body['data']['object']['amount']
    ReceiptEmailWorker.perform_async(email: email, amount: amount)
  end
end
