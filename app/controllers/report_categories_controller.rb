class ReportCategoriesController < ApplicationController
  before_filter :find_project
  before_filter :find_category, :only => [:edit, :destroy, :shift_up, :shift_down]

  def create
    last_category = @project.report_categories.order("position asc").last
    position = last_category.nil? ? 0 : last_category.position
    @project.report_categories.build(params[:report_category].merge({:position => position+1})).save
    redirect_to project_reports_path(@project)
  end

  def edit
    @category.update_attributes(params[:report_category])
    redirect_to project_reports_path(@project)
  end

  def destroy
    @category.reports.each do |report|
      report.update_attribute(:report_category_id, nil)
    end
    @category.destroy
    redirect_to project_reports_path(@project)
  end

  def shift_up
    last_category = @project.report_categories.where("position < ?", @category.position).order("position asc").last
    if not last_category.nil?
      position = last_category.position
      last_category.update_attribute(:position, @category.position)
      @category.update_attribute(:position, position)
    end
    redirect_to project_reports_path(@project)

  end

  def shift_down
    first_category = @project.report_categories.where("position > ?", @category.position).order("position asc").first
    if not first_category.nil?
      position = first_category.position
      first_category.update_attribute(:position, @category.position)
      @category.update_attribute(:position, position)
    end
    redirect_to admin_template_reports_path(@project)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_category
    @category = ReportCategory.find(params[:id])
  end

end
