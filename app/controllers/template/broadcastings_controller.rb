class Template::BroadcastingsController < Template::BaseController
  before_filter :find_broadcasting

  def index
    render :json => [@broadcasting.js_attributes]
  end

  def create
    self.update
  end

  def update
    if @broadcasting.update_attributes(params[:broadcasting])
      render :json => @broadcasting.js_attributes
    else
      render :json => @broadcasting.js_attributes, :status => 400
    end
  end

  def destroy
    @broadcasting.message=""
    if @broadcasting.save
      render :json => @broadcasting.js_attributes
    else
      render :json => @broadcasting.js_attributes, :status => 400
    end
  end

  private

  def find_broadcasting
    @broadcasting = Broadcasting.all()[0]
    if @broadcasting.blank?
      @broadcasting = Broadcasting.new()
      @broadcasting.id = 1
      @broadcasting.save
    end
  end
end