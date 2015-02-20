class SubscriptionsController < DonationsController

  before_filter :find_or_create_donor

  def create
    @plan = StripePlan.find_or_create_by!({
      amount: plan_params[:amount].to_i * 100
    })

    @subscription = StripeSubscription.create!(
      donor: @donor,
      plan: @plan
    )

    redirect_to thanks_path
  end
end
