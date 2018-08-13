class StripeEvent < ApplicationRecord
  CHARGE_SUCCEEDED = "charge.succeeded".freeze

  validates_presence_of :stripe_id, :body

  def self.record_and_process(stripe_event)
    find_by(stripe_id: stripe_event.id) || create!(
      stripe_id: stripe_event.id,
      body: stripe_event.as_json
    ).process
  end

  def process
    return if processed?
    queue_email_receipt_mail if should_email_receipt?
    mark_processed!
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

  def recurring?
    body['data']['object']['invoice'].present?
  rescue StandardError
    false
  end

  private

  def should_email_receipt?
    type == CHARGE_SUCCEEDED
  end

  def customer_id
    body['data']['object']['customer']
  end

  def queue_email_receipt_mail
    email = Donor.find_by(stripe_customer_id: customer_id).email
    amount = body['data']['object']['amount']
    ReceiptMailer.delay.notify_of_donation(email: email, amount: amount, recurring: recurring?)
  end

  def processed?
    processed_at.present?
  end
end
