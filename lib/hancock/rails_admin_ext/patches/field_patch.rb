require 'rails_admin'
module RailsAdmin
  module Config
    module Fields

      class Base
        register_instance_option :weight do
          0
        end


        def render_object
          (bindings && (bindings[:view] || bindings[:controller]))
        end


        def current_object
          (bindings && bindings[:object])
        end

        def is_current_object_new
          current_object.is_new?
        end


        def current_user
          (render_object and render_object.current_user and render_object.current_user)
        end

        def is_current_user_admin
          !!(_current_user = current_user and _current_user.admin?)
        end

      end

    end
  end
end
