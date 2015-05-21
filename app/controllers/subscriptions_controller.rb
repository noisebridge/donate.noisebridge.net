class SubscriptionsController < DonationsController

  before_filter :find_or_create_donor

  def create
    plan = StripePlan.find_or_create_by!({
      amount: plan_params[:amount].to_i * 100
    })

    @subscription = StripeSubscription.new(
      donor: @donor,
      plan: plan
    )

    if @subscription.save
      redirect_to thanks_path
    else
      flash[:danger] = @subscription.errors.full_messages
      redirect_to recurring_path
    end
  end
end
