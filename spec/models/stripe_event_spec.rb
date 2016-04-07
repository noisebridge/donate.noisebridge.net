require "rails_helper"

RSpec.describe StripeEvent do

  it { is_expected.to validate_presence_of(:stripe_id) }
  it { is_expected.to validate_presence_of(:body) }

  context "#mark_processed!" do
    let(:event) { StripeEvent.create!(stripe_id: "foo", body: {key: "value"}) }

    it "sets the processed_at timestamp" do
      expect {event.mark_processed! }.to change { event.reload.processed_at }
    end
  end

end
