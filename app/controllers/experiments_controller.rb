class ExperimentsController < ApplicationController
  before_action :only_admins
  before_action :set_experiment, only: [:edit, :update, :destroy]

  def index
    @experiments = Experiment.all
  end

  def new
    @experiment = Experiment.new
  end

  def edit
  end

  def create
    @experiment = Experiment.new(experiment_params)

    if @experiment.save
      redirect_to experiments_path
    else
      render :new
    end
  end

  def update
    if @experiment.update(experiment_params)
      redirect_to experiments_path
    else
      render :edit
    end
  end

  def destroy
    @experiment.destroy
    redirect_to experiments_url
  end

  private

  def set_experiment
    @experiment = Experiment.find(params[:id])
  end

  def experiment_params
    params.require(:experiment).permit(:name, :price)
  end
end
