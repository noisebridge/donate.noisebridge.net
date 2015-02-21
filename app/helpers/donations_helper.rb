module DonationsHelper
  # All amounts in cents
  DONATIONS_GOAL = 20_000_00

  STANDARD_DONATION_AMOUNTS = [
    10,
    20,
    40,
    80,
    160
  ]

  def top_ten_charges
    Charge.order('amount DESC').limit(10)
  end

  def total_raised
    Charge.sum(:amount)
  end

  def percentage_raised
    (total_raised / DONATIONS_GOAL) * 100
  end

  def amounts
    STANDARD_DONATION_AMOUNTS.map do |i|
      [number_to_currency(i, precision: 0), i]
    end + [["Other", "other"]]
  end

  def select_amount(name)
    select_tag(name, options_for_select(amounts, params[:amount]), class: 'form-control')
  end
end

