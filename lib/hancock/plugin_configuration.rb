module Hancock::PluginConfiguration

  module ClassMethods
    def configuration
      @configuration ||= config_class.new if config_class
    end
    def config
      configuration
    end

    def configure
      yield configuration
    end

    def reconfigure!
      if config_class
        @configuration = config_class.new
        configure &block if block_given?
      end
    end

    def config_class
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

end
