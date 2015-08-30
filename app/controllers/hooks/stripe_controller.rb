module Hooks
  class StripeController < HooksController
    def create
      notification = fetch_stripe_notification
      StripeWebhook.process(notification)
      head :ok
    rescue JSON::ParserError
      Rails.logger.warn("Received badly formed Stripe webhook")
      head 500
    rescue Stripe::InvalidRequestError => e
      Rails.logger.warn(e)
      head 500
    end

    private

    def fetch_stripe_notification
      Stripe::Event.retrieve(parsed_json[:id])
    end

    def parsed_json
      @parsed_json ||= JSON.parse(request.body.read, symbolize_names: true)
    end
  end
end
