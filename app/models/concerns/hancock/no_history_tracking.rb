module Hancock::NoHistoryTracking
  extend ActiveSupport::Concern

  included do
    def set_creator; nil; end
    def set_updater; nil; end
  end

  class_methods do    
    def track_history?
      false
    end
  end

end
