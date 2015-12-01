class StripeEvent < ActiveRecord::Base

  # required to allow us to use the type column which is by default reserved for
  # Rail's Single Table Inheritance code
  self.inheritance_column = :subclass_type

  validates_presence_of :stripe_id, :remote_created_at, :type

  def self.create_from_stripe_event(event)
    create!(
      data: event.data.as_json,
      remote_created_at: Time.at(event.created).utc,
      request: event.request,
      stripe_id: event.id,
      type: event.type,
    )
  end
end
