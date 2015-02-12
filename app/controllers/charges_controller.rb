class ChargesController < DonationsController

  before_filter :find_or_create_donor

  def create
    @charge = @donor.charges.create(charge_params)

    if @charge.save
      flash[:success] = "Thanks for your donation!"
      redirect_to(thanks_path)
    else
      respond :json, @charge.errors
    end
  end
end
