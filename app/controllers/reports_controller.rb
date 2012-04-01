class ReportsController < ProjectBaseController
  set_tab :report, :sub
  before_filter :find_report, :only => [:show, :edit, :update, :destroy, :request_data]
  
  def index
    @reports = @project.reports.paginate(:page => params[:page])
  end
  
  def new
    if params[:template_id].nil?
      @report = @project.reports.build
      @report.build_period
    else
      template = Report.find(params[:template_id])
      if (not template.nil?) and template.template == 1
        @report = template.clone_as_template(@project.id)
      else
        @report = @project.reports.build
        @report.build_period
      end
    end

  end
  
  def create
    report_type = params[:report].delete(:type)
    if Report.subclasses.map(&:name).include?(report_type)
      @report = report_type.constantize.new(params[:report])
      @report.project = @project
    else
      @report = @project.reports.build(params[:report])
    end
    
    if @report.save
      redirect_to project_report_path(@project, @report), :notice => t("report.create.success")
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
      redirect_to project_report_path(@project, @report), :notice => t("report.update.success")
    else
      render :edit
    end
  end
  
  def destroy
    @report.destroy
    redirect_to project_reports_path(@project), :notice => t("report.delete.success")
  end
  
  def show
    @default_start_time = @report.start_time
    @default_end_time = @report.end_time
    render :layout => "application"
  end
  
  def request_data
    if params[:test] == "true"
      index = 0
      random_data = (Time.parse(params[:start_time]).to_i..Time.parse(params[:end_time]).to_i).step(@report.interval).map {|time|
        index += 1
        [Time.at(time).to_s, rand(100) + index * 10]
      }
      pp random_data
      render :json => {:result => true, :data => random_data}
    else
      @metric = @report.metrics.find(params[:metric_id])
      json = AnalyticService.new(@report, params).request_metric_data(@metric)
      
      render :json => json
    end
  rescue Timeout::Error => e
    render :json => {:result => false, :timeout => true, :error => e.message}
  rescue Exception => e
    render :json => {:result => false, :error => e.message}
  end

  def choose_template
    @template_reports = Report.find_all_by_template(1)
  end

  def import_template
    @project.create_template_menus
    redirect_to project_reports_path(@project), :notice => "Imported"
  end
  
  private
  
  def find_report
    @report = @project.reports.find(params[:id])
  end
  
end
