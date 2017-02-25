require "rails_helper"

RSpec.describe Api::StripeEventsController do
  let(:event) { create(:stripe_event) }

  context "POST #create" do
    it "retrieves the Stripe::Event and persists it" do
      expect(Stripe::Event).to receive(:retrieve)
        .with(event.stripe_id)
        .and_return(true)
      expect(StripeEvent).to receive(:record_and_process)

      post :create, body: { id: event.stripe_id }.to_json, format: :json

      expect(response).to be_success
    end

    context "with bad JSON" do
      it "returns 500" do
        post :create, body: "this is a thing", format: :json
        expect(response.code).to eq("400")
      end
    end
  end
end
