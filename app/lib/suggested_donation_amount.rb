class SuggestedDonationAmount

  SUGGESTED_AMOUNTS = {
    laser: [
      20,
      50,
      100,
      500,
      1000
    ],
    default: [
      10,
      20,
      40,
      80,
      160
    ]
  }

  def self.for_project(name)
    return SUGGESTED_AMOUNTS[:default] unless name.present?
    SUGGESTED_AMOUNTS[name.to_sym] ||
      SUGGESTED_AMOUNTS[:default]
  end
end
