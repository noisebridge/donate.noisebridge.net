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

  def top_ten_charges
    Charge.order('amount DESC').limit(10)
  end

  def donation_goal
    DONATIONS_GOAL
  end

  def total_raised
    Charge.sum(:amount)
  end

  def percentage_raised
    (total_raised / DONATIONS_GOAL.to_f) * 100
  end

  def amounts
    STANDARD_DONATION_AMOUNTS.map do |i|
      [number_to_currency(i, precision: 0), i]
    end + [["Other", "other"]]
  end

  def dues_amounts
    STANDARD_DUES_AMOUNT.map do |amount, label|
      ["#{number_to_currency(amount, precision: 0)} - #{label}", amount]
    end
  end

  def select_amount(name)
    select_tag(name, options_for_select(amounts, params[:amount]), class: 'form-control')
  end

  def dues_select_amount(name)
    select_tag(name, options_for_select(dues_amounts, params[:amount]), class: 'form-control')
  end

  def standard_donation_amounts
    STANDARD_DONATION_AMOUNTS
  end

  def paypal_donation_link(amount)
    link_to "#{number_to_currency(amount, precision: 0)} / month",
      "https://www.paypal.com/subscriptions/business=treasurer@noisebridge.net&item_name=Noisebridge%20Monthly%20Donation%20%28Affiliate%20Member%29&cy_code=USD&a3=#{amount}&p3=1&t3=M&src=1", target: "_blank"
  end
end

