class SettingsController < ProjectBaseController
  before_filter :find_setting, :only => [:update, :show]

  def show
    if @setting.blank?
      render :json => {}
    else
      render :json => @setting.js_attributes
    end
  end

  def create
    @setting = Setting.new(params[:setting].merge({:project_id => @project.id}))
    if @setting.save
      render :json => @setting.attributes
    else
      render :json => @setting.attributes, :status => 400
    end
  end

  def update
    if @setting.update_attributes(params[:setting])
      render :json => @setting.attributes
    else
      render :json => @setting.attributes, :status => 400
    end
  end

  private

  def find_setting
    @setting = @project.setting
  end
end