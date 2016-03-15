class Project
  PROJECTS = {
    laser: {
      suggested_donation_amounts: [
        1000,
        500,
        100,
        50,
        20,
      ],
      # All amounts in dollar cents
      fundraising_goal: 6_000_00
    },
    default: {
      suggested_donation_amounts: [
        10,
        20,
        40,
        80,
        160
      ],
    }
  }

  attr_accessor :name, :fundraising_goal, :suggested_donation_amounts

  def self.find(name)
    PROJECTS.map do |project, params|
      if project == name.to_sym
        return new(name, params)
      end
    end
    return new(PROJECTS[:default])
  end

  def initialize(name, params)
    @name = name
    @suggested_donation_amounts = params[:suggested_donation_amounts]
    @fundraising_goal = params[:fundraising_goal]
  end

  def amount_raised
    @amount_raised = Charge.tagged.where(tag: @name).sum(:amount)
  end

  def percentage_raised
    amount_raised / (fundraising_goal.to_f) * 100
  end

  def has_fundraising_goal?
    fundraising_goal.present?
  end
end
