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

  STANDARD_DUES_AMOUNT = [
    [40, "Starving hacker"],
    [80, "Regular"],
    [160, "Doing well"]
  ]

  def recent_donations
    Charge.all.order('created_at DESC').limit(5)
  end

  def projects
    Charge.project_totals
  end

  def fundraising_goal
    DONATIONS_GOAL
  end

  def total_raised
    Charge.sum(:amount)
  end

  def percentage_raised
    (total_raised / DONATIONS_GOAL.to_f) * 100
  end

  def amounts(name = nil)
    SuggestedDonationAmount.for_project(name).map do |i|
      [number_to_currency(i, precision: 0), i]
    end + [["Other", "other"]]
  end

  def dues_amounts
    STANDARD_DUES_AMOUNT.map do |amount, label|
      ["#{number_to_currency(amount, precision: 0)} - #{label}", amount]
    end
  end

  def select_amount(name)
    select_tag(name, options_for_select(amounts(@name), params[:amount]), class: 'form-control')
  end

  def dues_select_amount(name)
    select_tag(name, options_for_select(dues_amounts, params[:amount]), class: 'form-control')
  end

  def standard_donation_amounts
    STANDARD_DONATION_AMOUNTS
  end
end

