module Hancock::RailsAdminPatch
  extend ActiveSupport::Concern

  def rails_admin_model
    self.class.rails_admin_model
  end

  module ClassMethods
    def rails_admin_model
      to_param.gsub("::", "~").underscore
    end

    def rails_admin_add_fields
      {}
    end

    def rails_admin_add_config(config)
    end



    def admin_can_default_actions
      [:manage]
    end
    def admin_can_add_actions
      []
    end
    def admin_can_actions
      admin_can_default_actions + admin_can_add_actions
    end
    def admin_cannot_actions
      []
    end

    def manager_can_default_actions
      [:show, :read, :new, :create, :edit, :update]
    end
    def manager_can_add_actions
      []
    end
    def manager_can_actions
      manager_can_default_actions + manager_can_actions
    end
    def manager_cannot_actions
      []
    end

    def rails_admin_default_visible_actions
      [:comments, :model_comments]
    end
    def rails_admin_add_visible_actions
      []
    end
    def rails_admin_visible_actions
      rails_admin_default_visible_actions + rails_admin_add_visible_actions
    end

  end
end
