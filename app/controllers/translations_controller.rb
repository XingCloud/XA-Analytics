class TranslationsController < ProjectBaseController
  def index
    render :json => Translation.where({:locale => I18n.locale}).map(&:attributes)
  end
end