module Hancock::Controller
  extend ActiveSupport::Concern
  included do

    before_action do
      request.params.delete('rack.session')
      @clear_og_url = true
    end
    

    include Hancock::ControllerSettings
    include Hancock::Errors
    
    if defined?(Hancock::Pages)
      include Hancock::Pages::SeoPages
      include Hancock::Pages::NavMenu
      include Hancock::Pages::Blocksetable
    end
    protect_from_forgery prepend: true, with: :exception
    helper_method :seo_object
    helper_method :hancock_page_title
    helper_method :hancock_app_name
    helper_method :hide_ym_ga
  end

  protected
  def seo_object
  end
  def page_title
    seo_object&.title
  end

  def hancock_page_title
    _page_title = page_title
    if _page_title.blank?
      _page_title = (defined?(::Settings) ? ::Settings.default_title : "") #temp
    end
    _page_title
  end
  def hancock_app_name
    hancock_settings(
      key: 'page_title_app_name',
      label: "Постфикс названия сайта для title",
      default: Rails.application.class.name.split('::')[0],
      kind: :string
    )
    # hancock_cache_settings(
    #   key: 'page_title_app_name',
    #   label: "Постфикс названия сайта для title",
    #   default: Rails.application.class.name.split('::')[0],
    #   kind: :string
    # )
  end


  # def ckeditor_authenticate
  #   redirect_to '/' unless user_signed_in? && current_user.has_role?('admin')
  # end


  def hide_ym_ga
    false
  end


  def current_flashes_blank?
    # flash.now.flash.blank? and session[:cookies_notification_was_accepted]
    flash.now.flash.blank?# and session[:cookies_notification_was_accepted]
  end
  def page_blank?
    params[:page].blank?
  end


  def rails_admin?
    # false
    rails_admin_controller?
  end
  def rails_admin_controller?
    false
  end

end
