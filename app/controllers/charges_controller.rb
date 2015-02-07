class ChargesController < DonationsController

  before_filter :find_or_create_donor

  def create

    @charge = @donor.charges.create(charge_params)

    if @charge.persisted?
      head :created
    else
      respond :json, @charge.errors
    end
  end
end
