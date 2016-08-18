module Hancock::Localizeable
  extend ActiveSupport::Concern
  included do
    before_filter do
      I18n.locale = params[:locale] || I18n.default_locale
      Settings.ns_default = "main_#{I18n.locale}"
      Settings.ns_fallback = "main"
    end
  end
  private
  def default_url_options(options={})
    {locale: I18n.locale}
  end
  def nav_get_menu_items(type)
    pages = menu_class.find(type.to_s).pages.enabled
    if Hancock.mongoid?
      pages = pages.where(:"name.#{I18n.locale}".exists => true)
    elsif Hancock.active_record?
      pages = pages.where(["EXIST(name_translations, ?) = TRUE AND name_translations -> ? != ''", I18n.locale, I18n.locale])
    end
    pages.sorted.to_a
  end
  def nav_get_url(item)
    _connectable = item.connectable
    if _connectable and _connectable.enabled
      begin
        _routes_namespace = _connectable.respond_to?(:routes_namespace) ? _connectable.routes_namespace : :main_app
        _url = send(_routes_namespace.to_sym).url_for([_connectable, {only_path: true}])
      rescue Exception => exception
        Rails.logger.error exception.message
        Rails.logger.error exception.backtrace.join("\n")
        puts exception.message
        puts exception.backtrace.join("\n")
        capture_exception(exception) if respond_to?(:capture_exception)

        _url = item.redirect.blank? ? item.fullpath : item.redirect
      end
    else
      _url = item.redirect.blank? ? item.fullpath : item.redirect
    end
    _localizable_regexp = Regexp.new("^(#{I18n.available_locales.map { |l| "\\/#{l}"}.join("|")})")
    ((params[:locale].blank? or _url =~ _localizable_regexp) ? "" : "/#{params[:locale]}") + _url
  end
  def find_seo_extra(path)
    _localizable_regexp = Regexp.new("^(#{I18n.available_locales.map { |l| "\\/#{l}"}.join("|")})")
    _path = path.sub(_localizable_regexp, "")
    if _path[0] != '/'
      _path = '/' + _path
    end
    page_class.enabled.where(fullpath: _path).first
  end

  def page_class_name
    "Hancock::Pages::Page"
  end
  def page_class
    page_class_name.constantize
  end

  def menu_class_name
    "Hancock::Pages::Menu"
  end
  def menu_class
    menu_class_name.constantize
  end
end
