require 'rails_admin'
module RailsAdmin
  module Config
    module Fields

      class Group
        register_instance_option :leftside_hider do
          true
        end
      end

    end
  end
end
