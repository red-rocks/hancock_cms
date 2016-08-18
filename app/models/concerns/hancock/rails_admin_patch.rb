module Hancock::RailsAdminPatch
  extend ActiveSupport::Concern

  def rails_admin_model
    self.class.to_param.gsub("::", "~").underscore
  end

  module ClassMethods
    def rails_admin_add_fields
      {}
    end

    def rails_admin_add_config(config)
    end
  end
end
