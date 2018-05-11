require 'rails_admin'
module RailsAdmin
  module Config
    module Fields

      class Base
        register_instance_option :weight do
          0
        end

        def is_current_user_admin
          render_object = (bindings and (bindings[:controller] || bindings[:view]))
          render_object and render_object.current_user and render_object.current_user.admin?
        end

      end

    end
  end
end
