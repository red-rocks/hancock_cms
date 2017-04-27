module Hancock::BooleanField
  extend ActiveSupport::Concern

  class_methods do

    def boolean_field(name, default = true)
      if default.is_a?(Hash)
        default = default[:default]
      end

      if Hancock.mongoid?
        field name, type: Mongoid::Boolean, default: default
      end
      scope name, -> { where(name => true) }

      if name == 'active'
        scope :inactive,  -> { where(active: false) }
      elsif name == 'enabled'
        scope :disabled,  -> { where(enabled: false) }
      end
      
    end

  end

end
