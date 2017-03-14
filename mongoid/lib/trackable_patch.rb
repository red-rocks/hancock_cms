module TrackablePatch
  extend ActiveSupport::Concern

  included do

    include Mongoid::History::Trackable
    include Mongoid::Userstamp

    track_history({
      on: :fields,
      track_create: true,
      track_destroy: true,
      track_update: true,
      modifier_field: :updater,
      except: ["created_at", "updated_at", "c_at", "u_at"],
    })
    
    belongs_to :updater, class_name: Mongoid::History.modifier_class_name, optional: true, validate: false
    _validators.delete(:updater)
    _validate_callbacks.each do |callback|
      if callback.raw_filter.respond_to?(:attributes) and callback.raw_filter.attributes.include?(:updater)
        _validate_callbacks.delete(callback)
      end
    end

  end

end
