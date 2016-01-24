class ProjectsController < DonationsController
  def show
    @name = params[:id]
  end

  def index
    @project_totals = Charge.project_totals
  end
end
