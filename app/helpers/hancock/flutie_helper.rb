module Hancock::FlutieHelper
  
  # def flutie_page_title(options = {})
  def site_page_title(options = {})
    default_options = {
      app_name: hancock_app_name,
      page_title_symbol: :site_page_title, 
      reverse: true, 
      separator: " | "
    }
    if defined?(Flutie)
      
      flutie_page_title = Flutie::PageTitle.new(options.reverse_merge(default_options))
      
      # Flutie and HancockCMS compatibility fix
      # current_page_title = super()
      current_page_title = get_current_page_title || content_for(flutie_page_title.page_title_symbol)

      # return current_page_title if request.path == "/"
      if seo_object and seo_object.respond_to?(:use_title_constructor) and !seo_object.use_title_constructor
        return current_page_title
      end


      Flutie::PageTitlePresenter.new(
        flutie_page_title.app_name || hancock_app_name,
        current_page_title,
        flutie_page_title.separator,
        flutie_page_title.options[:reverse]
      ).to_s

    else
      options.reverse_merge!(default_options)
      title_array = [(options[:app_name] || hancock_app_name), get_current_page_title].compact
      title_array.reverse! if options[:reverse]
      title_array.join(options[:separator])
    end
  end

  def get_current_page_title
    current_page_title = current_page_title
    current_page_title = nil if current_page_title.blank?
    current_page_title
  end

end
