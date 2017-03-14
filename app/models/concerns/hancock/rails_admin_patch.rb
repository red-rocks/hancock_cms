module Hancock::RailsAdminPatch
  extend ActiveSupport::Concern

  def rails_admin_model
    self.class.rails_admin_model
  end

  def admin_can_actions
    self.class.admin_can_actions
  end
  def admin_cannot_actions
    self.class.admin_cannot_actions
  end
  def manager_can_actions
    self.class.manager_can_actions
  end
  def manager_cannot_actions
    self.class.manager_cannot_actions
  end

  class_methods do
    def rails_admin_model
      name.split('::').collect(&:underscore).join('~')
    end
    def rails_admin_param_key
      name.split('::').collect(&:underscore).join('_')
    end

    def rails_admin_add_fields
      []
    end

    def rails_admin_add_config(config)
    end

    def rails_admin_name_synonyms
      ''.freeze
    end


    def admin_can_default_actions
      [:manage].freeze
    end
    def admin_can_add_actions
      [].freeze
    end
    def admin_can_user_defined_actions
      [].freeze
    end
    def admin_can_actions
      (admin_can_default_actions + admin_can_add_actions + admin_can_user_defined_actions).uniq.freeze
    end
    def admin_cannot_default_actions
      [].freeze
    end
    def admin_cannot_add_actions
      [].freeze
    end
    def admin_cannot_user_defined_actions
      [].freeze
    end
    def admin_cannot_actions
      (admin_cannot_default_actions + admin_cannot_add_actions + admin_cannot_user_defined_actions).uniq.freeze
    end

    def manager_can_default_actions
      [:index, :show, :read, :new, :create, :edit, :update].freeze
    end
    def manager_can_add_actions
      [].freeze
    end
    def manager_can_user_defined_actions
      [].freeze
    end
    def manager_can_actions
      (manager_can_default_actions + manager_can_add_actions + manager_can_user_defined_actions).uniq.freeze
    end
    def manager_cannot_default_actions
      [:model_accesses, :user_abilities].freeze
    end
    def manager_cannot_add_actions
      [].freeze
    end
    def manager_cannot_user_defined_actions
      [].freeze
    end
    def manager_cannot_actions
      (manager_cannot_default_actions + manager_cannot_add_actions + manager_cannot_user_defined_actions).uniq.freeze
    end

    def rails_admin_default_visible_actions
      [].freeze
    end
    def rails_admin_add_visible_actions
      [].freeze
    end
    def rails_admin_user_defined_visible_actions
      [].freeze
    end
    def rails_admin_visible_actions
      (rails_admin_default_visible_actions + rails_admin_add_visible_actions + rails_admin_user_defined_visible_actions).uniq.freeze
    end

  end
end
