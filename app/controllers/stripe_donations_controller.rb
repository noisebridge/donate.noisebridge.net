class StripeDonationsController < ApplicationController
  def create
    plan = StripePlan.find_or_create_by!(plan_params)
    donor = Donor.create!(donor_params)

    @subscription = StripeSubscription.create!(
      donor: donor,
      plan: plan,
    )

    respond_to do |format|
      format.html
      format.json { @subscription.json }
    end
  end

  private

  def donor_params
    params.require(:donor).permit(:email, :stripe_token)
  end

  def plan_params
    params.require(:plan).permit(:amount)
  end
end
