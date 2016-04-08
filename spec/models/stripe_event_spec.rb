require "rails_helper"

RSpec.describe StripeEvent do

  it { is_expected.to validate_presence_of(:stripe_id) }
  it { is_expected.to validate_presence_of(:body) }

  context ".record_and_process" do
    let!(:event) { create(:stripe_event) }

    it "creates an event and processes it" do
      expect_any_instance_of(subject.class).to receive(:process).and_return(true)

      expect {
        subject.class.record_and_process(event)
      }.to change(StripeEvent, :count).by(1)
    end

    it "does not create duplicate records" do
      expect {
        subject.class.record_and_process(event)
        subject.class.record_and_process(event)
      }.to change(StripeEvent, :count).by(1)
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
        build(:stripe_event,
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

      context "with an aleady processed event" do
        let(:event) { create(:stripe_event, processed_at: 2.days.ago) }

        it "does nothing" do
          expect(event.process).to eq(nil)
        end
      end

      it "queues an email recipt email" do
        expect(ReceiptMailer).to receive_message_chain(:delay, :notify_of_donation).
          with(email: donor.email, amount: 100_00, recurring: false).
          and_return(true)
        expect(event.process).to eq(true)
      end

      it "marks as processed!" do
        event = create(:stripe_event)
        expect {
          event.process
        }.to change { event.reload.processed_at }
      end
    end
  end

  context "#recurring?" do
    let!(:recurring) { create(:stripe_event, body: { data: { object: { invoice: "invoice-1" } } }) }
    let!(:once_off) { create(:stripe_event) }

    it "returns true if the charge is associated with an invoice" do
      expect(recurring.recurring?).to eq(true)
    end

    it "returns false if the charge is not associated with an invoice" do
      expect(once_off.recurring?).to eq(false)
    end
  end
end
