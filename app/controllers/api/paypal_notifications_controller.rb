module Api
  class PaypalNotificationsController < ApplicationController
    skip_before_action :verify_authenticity_token

    rescue_from ActiveRecord::RecordNotUnique, with: :duplicate_notification

    def create
      if PaypalNotification.verify_raw_payload(request.raw_post)
        PaypalNotification.create_from_payload(params)
        render plain: 'VERIFIED', status: 200
      else
        render plain: 'UNVERIFIED', status: 400
      end
    end

    private

    def duplicate_notification
      Rails.logger.info("Received duplicate notification: #{params['txn_id']}")
      render plain: 'INVALID', status: 400
    end
  end
end
