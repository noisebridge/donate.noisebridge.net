class DonationsController < ApplicationController

  def index
  end

  def thanks
    @title = "Thanks!"
  end

  def project
    @name = params[:project]
  end

  private

  def donor_params
    params.require(:donor).permit(:email, :stripe_token, :name, :anonymous)
  end

  def charge_params
    params.require(:charge).permit(:amount, :recurring, :tag)
  end

  def plan_params
    params.require(:plan).permit(:amount)
  end

  def find_or_create_donor
    @donor = if Donor.exists?(email: donor_params[:email])
      Donor.find_by(email: donor_params[:email])
    else
      create_donor
    end
  end

  def create_donor
    donor = Donor.new(donor_params)
    if !donor.save
      flash[:danger] = donor.errors.full_messages
      return redirect_to root_url
    end
    donor
  end
end
