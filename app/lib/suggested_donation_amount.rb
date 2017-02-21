class SuggestedDonationAmount
  ### Amounts in whole dollar USD
  SUGGESTED_AMOUNTS = {
    laser: [
      1000,
      500,
      100,
      50,
      20
    ],
    stickers: [
      5,
      10,
      25,
      50,
      100
    ],
    default: [
      10,
      20,
      40,
      80,
      160
    ]
  }.freeze

  def self.for_project(name)
    return SUGGESTED_AMOUNTS[:default] unless name.present?
    SUGGESTED_AMOUNTS[name.to_sym] ||
      SUGGESTED_AMOUNTS[:default]
  end
end
