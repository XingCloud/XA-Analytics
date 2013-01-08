class ActionLogsController < ProjectBaseController
  def index
    max_page = (@project.action_logs.length / 10.0).ceil
    params[:page] = 1 unless params[:page].present?
    if params[:page].to_i > 0
      logs = @project.action_logs.paginate(:page => params[:page], :per_page => 10, :order => "perform_at DESC")
      render :json => {:action_logs => logs.map(&:attributes), :max_page => max_page}
    else
      render :json => {:action_logs => [], :max_page => max_page}, :status => 400
    end
  end
end