module Hancock::Controller
  extend ActiveSupport::Concern
  included do
    include Hancock::Errors
    include Hancock::Fancybox
    if defined?(Hancock::Pages)
      include Hancock::Pages::SeoPages
      include Hancock::Pages::NavMenu
      include Hancock::Pages::Blocksetable
    end
    protect_from_forgery with: :exception
    helper_method :page_title
    helper_method :hide_ym_ga
  end

  protected

  def page_title
    Settings ? Settings.default_title : "" #temp
  end

  def ckeditor_authenticate
    redirect_to '/' unless user_signed_in? && current_user.has_role?('admin')
  end


  def hide_ym_ga
    false
  end

  # HARD Rails5 compatibility
  def redirect_back(fallback_location:, **args)
    if referer = request.headers["Referer"]
      redirect_to referer, **args
    else
      redirect_to fallback_location, **args
    end
  end
end
