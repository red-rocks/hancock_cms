module Hancock::Plugin

  module ClassMethods
    def orm
      Hancock.orm
    end
    def mongoid?
      self.orm == :mongoid
    end
    def active_record?
      self.orm == :active_record
    end
    def model_namespace
      "#{self}::Models::#{self.orm.to_s.camelize}"
    end
    def orm_specific(name)
      "#{model_namespace}::#{name}".constantize
    end
  end

  def self.included(base)
    Hancock::register_plugin(base) unless base == Hancock
    base.extend(ClassMethods)
  end
end
