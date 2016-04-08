require "rails_helper"

describe ReceiptMailer, type: :mailer do
  let(:donor) { create(:donor) }
  let(:recurring) { ReceiptMailer.notify_of_donation(email: donor.email, amount: 100_00, recurring: true) }
  let(:one_time) { ReceiptMailer.notify_of_donation(email: donor.email, amount: 100_00, recurring: false) }

  describe "#notify_of_donation" do
    it "renders the body" do
      expect(recurring.body.encoded).to include("Your recurring donation")
    end

    it "uses the appropriate subject for one-time donations" do
      expect(recurring.subject).to include("We have received your recurring donation")
    end

    it "uses the appropriate subject for recurring donations" do
      expect(one_time.subject).to include("We have received your donation")
    end
  end
end
