class Admin::TemplateMetricsController < ApplicationController
  before_filter :find_metric, :only => [:edit, :update, :destroy]
  layout "dialog"

  def new
    @metric = Metric.new
    @metric.build_combine
  end

  def create
    @metric = Metric.new(params[:metric])
    if @metric.save
      flash.now[:notice] = t("metric.create.success")
    else
      @metric.combine || @metric.build_combine
      render :new
    end
  end

  def edit
    unless @metric.combine
      @metric.build_combine
    end
  end

  def update
    @metric.attributes=(params[:metric])
    if @metric.save
      flash.now[:notice] = t("metric.update.success")
    else
      render :edit
    end
  end

  def destroy
    @metric.destroy
    render :nothing => true
  end

  private

  def find_metric
    @metric = Metric.find(params[:id])
  end
end