class ReceiptEmailWorker
  include Sidekiq::Worker

  def perform(email:, amount:)
    ReceiptMailer.notify_of_donation(email, amount).deliver
  end
end
