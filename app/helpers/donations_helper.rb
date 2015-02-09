module DonationsHelper
  # All amounts in cents
  DONATIONS_GOAL = 20_000_00

  def top_ten_charges
    Charge.order('amount DESC').limit(10)
  end

  def total_raised
    Charge.sum(:amount)
  end

  def percentage_raised
    (total_raised / DONATIONS_GOAL) * 100
  end
end

