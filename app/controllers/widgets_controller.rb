class WidgetsController < ProjectBaseController
  before_filter :find_widget, :only => [:update, :destroy]

  def index
    check_templates
    widgets = []
    @project.widget_connectors.visible.each do |widget_connector|
      widgets.append(Widget.find(widget_connector.widget_id).js_attributes(@project.id))
    end
    render :json => widgets
  end

  def create
    @widget = @project.widgets.build(params[:widget].merge({:project_id => @project.id}))
    if @widget.save and @project.widget_connectors.create({:widget_id => @widget.id,
                                                           :px => params[:widget_connector][:px],
                                                           :py => params[:widget_connector][:py]})
      render :json => @widget.js_attributes
    else
      @widget.destroy unless @widget.id.blank?
      render :json => @widget.js_attributes, :status => 400
    end
  end

  def update
    error = false
    if @widget.project_id.blank?
      widget_connector = @widget.widget_connectors.find_by_project_id(@project.id)
      @widget = @project.widgets.build(params[:widget].merge({:project_id => @project.id}))
      Widget.transaction do
        begin
          widget_connector.update_attributes!(:display => 0)
          @widget.save!
          @project.widget_connectors.create!({:widget_id => @widget.id, :position => 1})
        rescue
          error = true
          raise ActiveRecord::Rollback
        end
      end
    else
      error = (not @widget.update_attributes(params[:widget]))
    end
    render :json => @widget.js_attributes, :status => (error ? 400 : 200)
  end

  def destroy
    error = false
    if @widget.project_id.blank?
      widget_connector = @widget.widget_connectors.find_by_project_id(@project.id)
      error = (not widget_connector.update_attributes({:display => 0}))
    else
      error = (not @widget.destroy)
    end
    render :json => @widget.js_attributes, :status => (error ? 400 : 200)
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
