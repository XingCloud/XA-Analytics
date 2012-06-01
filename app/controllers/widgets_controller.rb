class WidgetsController < ProjectBaseController
  before_filter :find_widget, :only => [:update, :destroy]

  def index
    check_templates
    widgets = []
    @project.project_widgets.visible.each do |project_widget|
      widgets.append(Widget.find(project_widget.widget_id).js_attributes(@project.id))
    end
    render :json => widgets
  end

  def create
    @widget = @project.widgets.build(params[:widget].merge({:project_id => @project.id}))
    if @widget.save and @project.project_widgets.create({:widget_id => @widget.id,
                                                           :px => params[:project_widget][:px],
                                                           :py => params[:project_widget][:py]})
      render :json => @widget.js_attributes(@project.id)
    else
      @widget.destroy unless @widget.id.blank?
      render :json => @widget.js_attributes(@project.id), :status => 400
    end
  end

  def update
    error = false
    if @widget.project_id.blank?
      project_widget = @widget.project_widgets.find_by_project_id(@project.id)
      @widget = @project.widgets.build(params[:widget].merge({:project_id => @project.id}))
      Widget.transaction do
        begin
          project_widget.update_attributes!(:display => 0)
          @widget.save!
          @project.project_widgets.create!({:widget_id => @widget.id, :position => 1})
        rescue
          error = true
          raise ActiveRecord::Rollback
        end
      end
    else
      error = (not @widget.update_attributes(params[:widget]))
    end
    render :json => @widget.js_attributes(@project.id), :status => (error ? 400 : 200)
  end

  def destroy
    error = false
    if @widget.project_id.blank?
      project_widget = @widget.project_widgets.find_by_project_id(@project.id)
      error = (not project_widget.update_attributes({:display => 0}))
    else
      error = (not @widget.destroy)
    end
    render :json => @widget.js_attributes(@project.id), :status => (error ? 400 : 200)
  end

  private

  def find_widget
    @widget = @project.widgets.find(params[:id])
  end

  def check_templates
    widget_ids = @project.widget_ids
    has_new_widgets = false
    Widget.template.each do |template|
      if widget_ids.index(template.id).blank?
        widget_ids.append(template.id)
        has_new_widgets = true
      end
    end
    @project.update_attributes!({:widget_ids => widget_ids}) unless not has_new_widgets
  end
end
