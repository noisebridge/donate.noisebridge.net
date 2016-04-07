require "rails_helper"

RSpec.describe StripeEvent do

  it { is_expected.to validate_presence_of(:stripe_id) }
  it { is_expected.to validate_presence_of(:body) }

  context ".record_and_process" do
    let(:event) { create(:stripe_event) }

    it "creates an event and processes it" do
      expect(subject.class).to receive(:create!).and_return(event)
      expect(event).to receive(:process).and_return(true)

      subject.class.record_and_process(event)
    end
  end

  context "#mark_processed!" do
    let(:event) { StripeEvent.create!(stripe_id: "foo", body: {key: "value"}) }

    it "sets the processed_at timestamp" do
      expect {event.mark_processed! }.to change { event.reload.processed_at }
    end
  end

  context "#remote_created_at" do
    let(:event) {
      subject.class.new(
        body: {
          'created': 0
        }
      )
    }

    it "returns the remote event created timestamp" do
      expect(event.remote_created_at).to eq(Time.at(0))
    end
  end

  context "#type" do
    let(:event) {
      subject.class.new(body: { "type": "foo.bar"} )
    }

    it "returns the event type" do
      expect(event.type).to eq("foo.bar")
    end
  end

  context "#process" do
    context "with a charge.succeeded" do
      let(:donor) { create(:donor) }
      let(:event) {
        subject.class.new(
          body: {
            type: "charge.succeeded",
            data: {
              object: {
                customer: donor.stripe_customer_id,
                amount: 100_00
              }
            }
          }
        )
      }

      it "queues an email recipt email" do
        expect(ReceiptEmailWorker).to receive(:perform_async).
          with(email: donor.email, amount: 100_00).
          and_return(true)
        expect(event.process).to eq(true)
      end
    end
  end
end
