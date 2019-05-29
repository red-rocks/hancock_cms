require 'rails_admin/config/actions'
require 'rails_admin/config/actions/edit'

module RailsAdmin
  module Config
    module Actions
      class HancockTabbedEdit < RailsAdmin::Config::Actions::Edit
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          'tabbed_edit'
        end

        register_instance_option :template_name do
          'rails_admin/main/hancock/tabbed_edit'
        end

        register_instance_option :link_icon do
          'fa fa-pencil-square-o'
        end
      end
    end
  end
end

