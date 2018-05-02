class DonationsController < ApplicationController
  def index; end

  def thanks
    @title = "Thanks!"
  end

  private def donor_params
    params.require(:donor).permit(:email, :stripe_token, :name, :anonymous)
  end

  private def charge_params
    params.require(:charge).permit(:amount, :recurring, :tag)
  end

  private def plan_params
    params.require(:plan).permit(:amount)
  end

  private def find_or_create_donor
    @donor = if Donor.exists?(email: donor_params[:email])
      find_and_update_donor
    else
      create_donor
    end
  end

  private def find_and_update_donor
    donor = Donor.find_by(email: donor_params[:email])
    donor.update_attributes!(donor_params)
    donor
  end

  private def create_donor
    donor = Donor.new(donor_params.to_h)
    unless donor.save
      flash[:danger] = donor.errors.full_messages
      return redirect_to root_url
    end
    donor
  end
end
