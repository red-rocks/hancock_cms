require 'rails_admin'
module RailsAdmin
  module Config
    module Fields

      class Base
        register_instance_option :weight do
          name.to_sym == :default ? -1_000_000 : 0
        end
      end

    end
  end
end
