class Template::TranslationsController < Template::BaseController
  before_filter :find_translation, :only => [:update, :destroy]

  def index
    render :json => Translation.all.map(&:attributes)
  end

  def create
    @translation = Translation.new(params[:translation])
    if @translation.save
      render :json => @translation.attributes
    else
      render :json => @translation.attributes, :status => 400
    end
  end

  def update
    if @translation.update_attributes(params[:translation])
      render :json => @translation.attributes
    else
      render :json => @translation.attributes, :status => 400
    end
  end

  def destroy
    if @translation.destroy
      render :json => @translation.attributes
    else
      render :json => @translation.attributes, :status => 500
    end
  end

  private

  def find_translation
    @translation = Translation.find(params[:id])
  end
end