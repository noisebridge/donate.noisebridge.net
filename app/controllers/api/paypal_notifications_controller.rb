class Api::PaypalNotificationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    if PaypalNotification.verify_raw_payload(request.raw_post)
      render plain: "VERIFIED", status: 200
    else
      render plain: "UNVERIFIED", status: 400
    end
  end
end
