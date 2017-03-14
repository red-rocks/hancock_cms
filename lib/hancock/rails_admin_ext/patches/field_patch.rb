require 'rails_admin'
module RailsAdmin
  module Config
    module Fields

      class Base
        register_instance_option :weight do
          0
        end

      end

    end
  end
end
