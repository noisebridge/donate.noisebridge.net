class ChargesController < DonationsController

  before_filter :find_or_create_donor

  def create
    @charge = @donor.charges.create(charge_params)

    if @charge.persisted?
      flash[:success] = "Thanks for your donation!"
      redirect_to(root_url)
    else
      respond :json, @charge.errors
    end
  end
end
