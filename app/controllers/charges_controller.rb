class ChargesController < DonationsController

  before_filter :find_or_create_donor

  def create
    if charge_params[:recurring] == "on"
      create_subscription
    else
      create_charge
    end
  end

  private

  def create_subscription
    return redirect_to root_url unless update_credit_card(donor_params[:stripe_token])

    plan = Plan.find_or_create_by!({
      amount: charge_params[:amount].to_i * 100
    })

    @subscription = Subscription.new(
      donor: @donor,
      plan: plan
    )

    if @subscription.save
      redirect_to thanks_path
    else
      flash[:danger] = @subscription.errors.full_messages
      redirect_to root_url
    end
  rescue Stripe::CardError => exc
    flash[:danger] = [exc.message] 
    redirect_to root_url
  end


  def create_charge
    return redirect_to root_url unless update_credit_card(donor_params[:stripe_token])

    # HACK TODO: fix the dollars / cents thing
    @charge = @donor.charges.new({
      amount: charge_params[:amount].to_i * 100,
      tag: charge_params[:tag]
    })

    if @charge.save
      redirect_to(thanks_path)
    else
      flash[:danger] = @charge.errors.full_messages
      redirect_to root_url
    end
  end

  private

  def update_credit_card(token)
    @donor.create_payment_source(token)
    true
  rescue Stripe::CardError => exc
    flash[:danger] = [exc.message] 
    false
  end
end
