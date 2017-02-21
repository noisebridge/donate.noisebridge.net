require "rails_helper"

describe PaypalNotification, type: :model do
  context ".verify_raw_payload" do
    it "works" do
      body = "param=value"
      expect(HTTParty).to receive(:post).with(
        PaypalNotification::IPN_VERIFY_URL,
        body: body
      ).and_return(double(body: "VERIFIED"))

      expect(PaypalNotification.verify_raw_payload(body)).to eq(true)
    end
  end

  context ".create_from_payload" do
    let(:params) {
      {
        "txn_id" => "123",
        "key" => "value"
      }
    }

    it "works" do
      expect {
        PaypalNotification.create_from_payload(params)
      }.to change(PaypalNotification, :count).by(1)

      notification = PaypalNotification.last
      expect(notification.notification_id).to eq("123")
    end
  end
end
