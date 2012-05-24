class WidgetsController < ProjectBaseController
  before_filter :find_widget, :only => [:update, :destroy]

  def index
    check_templates
    render :json => @project.widgets.map{|widget| widget.js_attributes(@project.id)}
  end

  def create
    @widget = @project.widgets.build(params[:widget])
    if @widget.save and @project.widget_connectors.create({:widget_id => @widget.id})
      render :json => @widget.js_attributes
    else
      @widget.destroy unless @widget.id.blank?
      render :json => @widget.js_attributes, :status => 400
    end
  end

  def destroy

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
