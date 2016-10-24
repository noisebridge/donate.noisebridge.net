class Project
  PROJECTS = {
    laser: {
      # All amounts in dollar cents
      fundraising_goal: 6_000_00
    },
    default: {
    }
  }

  attr_accessor :name, :fundraising_goal

  def self.find(name)
    PROJECTS.map do |project, params|
      if project == name.to_sym
        return new(name, params)
      end
    end
    return new(name, PROJECTS[:default])
  end

  def initialize(name, params)
    @name = name
    @fundraising_goal = params[:fundraising_goal]
  end

  def amount_raised
    @amount_raised = Charge.tagged.where(tag: @name).sum(:amount)
  end

  def has_fundraising_goal?
    fundraising_goal.present?
  end
end
