class Template::WidgetsController < Template::BaseController
  before_filter :find_widget, :only => [:update, :destroy]

  def index
    render :json => Widget.template.map(&:js_attributes)
  end

  def create
    @widget = Widget.new(params[:widget])
    if @widget.save
      render :json => @widget.js_attributes
    else
      render :json => @widget.js_attributes, :status => 400
    end
  end

  def update
    if @widget.update_attributes(params[:widget])
      render :json => @widget.js_attributes
    else
      render :json => @widget.js_attributes, :status => 400
    end
  end

  def destroy
    if @widget.destroy
      render :json => @widget.js_attributes
    else
      render :json => @widget.js_attributes, :status => 400
    end
  end

  private

  def find_widget
    @widget = Widget.find(params[:id])
  end

end