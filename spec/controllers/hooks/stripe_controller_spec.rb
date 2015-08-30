require 'rails_helper'

module Hooks
  describe StripeController, type: :controller do
    context "POST #create" do
      let(:payload) {
        { id: "event-id" }
      }
      let(:json) { JSON.generate(payload ) }

      it "retrieves and processes Stripe::Event" do
        expect(Stripe::Event).to receive(:retrieve).
          once.
          with(payload[:id])
        expect(StripeWebhook).to receive(:process)

        post :create, json, content_type: "application/json"
        expect(response).to be_success
      end

      it "raises 500 for bad JSON" do
        post :create, "test", content_type: "application/json"
        expect(response).to be_error
      end

      it "raises 500 and warns for bad event" do
        expect(Stripe::Event).to receive(:retrieve).
          once.
          and_raise(Stripe::InvalidRequestError.new("foo", "bar"))

        post :create, json, content_type: "application/json"
        expect(response).to be_error
      end
    end
  end
end
