class Project
  PROJECTS = {
    laser: {
      # All amounts in dollar cents
      fundraising_goal: 6_000_00
    },
    default: {
    }
  }.freeze

  attr_accessor :name, :fundraising_goal

  def self.find(name)
    PROJECTS.map do |project, params|
      return new(name, params) if project == name.to_sym
    end
    new(name, PROJECTS[:default])
  end

  def initialize(name, params)
    @name = name
    @fundraising_goal = params[:fundraising_goal]
  end

  def amount_raised
    @amount_raised = Charge.tagged.where(tag: @name).sum(:amount)
  end

  def fundraising_goal?
    fundraising_goal.present?
  end
end
