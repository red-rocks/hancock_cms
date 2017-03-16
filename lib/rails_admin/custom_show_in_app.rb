module RailsAdmin
  module Config
    module Actions
      class CustomShowInApp < RailsAdmin::Config::Actions::ShowInApp
        RailsAdmin::Config::Actions.register(self)

        # register_instance_option :visible? do
        #   authorized? && (bindings[:controller].main_app.url_for(bindings[:object]) rescue false)
        # end

        # register_instance_option :controller do
        #   Proc.new do
        #     if @object.class.name == 'Hancock::Pages::Page'
        #       if @object.fullpath.blank?
        #         redirect_to main_app.page_url(@object)
        #       else
        #         redirect_to @object.fullpath
        #       end
        #     elsif @object.class.name == 'Hancock::News::News'
        #       redirect_to main_app.news_url(@object)
        #     # elsif @object.class.name == 'Obj'
        #     #   redirect_to main_app.object_url(@object.category, @object)
        #     else
        #       redirect_to main_app.url_for(@object)
        #     end
        #   end
        # end

      end
    end
  end
end
