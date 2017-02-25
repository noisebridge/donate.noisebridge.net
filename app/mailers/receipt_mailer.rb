class ReceiptMailer < ActionMailer::Base
  def notify_of_donation(email:, amount:, recurring:)
    @amount = amount
    @donor = Donor.find_by(email: email)
    @recurring = recurring

    subject = recurring ? "We have received your recurring donation" : "We have received your donation"

    mail(
      from: 'Noisebridge <no-reply@donate.noisebridge.net>',
      to: email,
      subject: subject
    )
  end
end
