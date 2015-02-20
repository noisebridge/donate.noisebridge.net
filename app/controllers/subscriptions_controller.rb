class SubscriptionsController < DonationsController

  before_filter :find_or_create_donor

  def create
    plan = StripePlan.find_or_create_by!(plan_params)

    @subscription = StripeSubscription.create!(
      donor: @donor,
      plan: plan
    )

    redirect_to thanks_path
  end
end
