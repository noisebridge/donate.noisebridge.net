module ReceiptMailer < ActionMailer

  def notify_of_donation(email, amount)
    @amount = amount
    @donor = Donor.find_by(email: email)
    mail(
      from: 'Noisebridge <no-reply@donate.noisebridge.net>',
      to: email,
      subject: "We have received your recurring donation"
    )
  end
end
