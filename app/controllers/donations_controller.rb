class DonationsController < ApplicationController
  def index
  end

  private

  def donor_params
    params.require(:donor).permit(:email, :stripe_token)
  end

  def charge_params
    params.require(:charge).permit(:amount)
  end

  def plan_params
    params.require(:plan).permit(:amount)
  end

  def find_or_create_donor
    @donor = if Donor.exists?(email: donor_params[:email])
      Donor.find_by(email: donor_params[:email])
    else
      Donor.create!(donor_params)
    end
  end
end
