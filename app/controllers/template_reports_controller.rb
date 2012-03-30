class TemplateReportsController < ApplicationController
  before_filter :find_report, :only => [:edit, :update, :destroy]

  def index
    @reports = Report.where(:template => 1).paginate(:page => params[:page])
  end

  def new
    @report = Report.new
    @report.build_period
  end

  def create
    report_type = params[:report].delete(:type)
    params[:report][:template] = 1
    if Report.subclasses.map(&:name).include?(report_type)
      @report = report_type.constantize.new(params[:report])
    else
      @report = Report.new(params[:report])
    end

    if @report.save
      redirect_to template_reports_path(), :notice => t("report.create.success")
    else
      render :new
    end
  end

  def update
    report_type = params[:report].delete(:type)
    if Report.subclasses.map(&:name).include?(report_type)
      @report.update_column("type", report_type)
    end

    if @report.update_attributes(params[:report])
      redirect_to template_reports_path(), :notice => t("report.update.success")
    else
      render :edit
    end
  end

  def destroy
    @report.destroy
    redirect_to template_reports_path(), :notice => t("report.delete.success")
  end

  private

  def find_report
    @report = Report.find(params[:id])
  end
end
