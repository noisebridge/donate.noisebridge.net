class Api::StripeEventsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    # Parse incoming webhook. Retrieve the specified event from Stripe to
    # prevent posting of invalid & unauthorized data, record event in our local
    # SQL table and finally process it
    StripeEvent.record_and_process(stripe_event)
    head :created
  rescue JSON::ParserError
    return head 400
  rescue StandardError => exc
    Raven.capture_exception(exc, { affects: :stripe })
    head 500
  end

  private def json
    @json ||= JSON.parse(request.body.read)
  end

  private def stripe_event_id
    json['id']
  end

  private def stripe_event
    @stripe_event ||= Stripe::Event.retrieve(stripe_event_id)
  end
end
