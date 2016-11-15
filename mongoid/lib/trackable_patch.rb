module Mongoid
  module History
    module Trackable

      module ClassMethods
        def track_history(options = {})
          extend EmbeddedMethods

          options_parser = Mongoid::History::Options.new(self)
          options = options_parser.parse(options)

          field options[:version_field].to_sym, type: Integer

          belongs_to_modifier_options = { class_name: Mongoid::History.modifier_class_name, required: false }
          belongs_to_modifier_options[:inverse_of] = options[:modifier_field_inverse_of] if options.key?(:modifier_field_inverse_of)
          belongs_to options[:modifier_field].to_sym, belongs_to_modifier_options

          include MyInstanceMethods
          extend SingletonMethods

          delegate :history_trackable_options, to: 'self.class'
          delegate :track_history?, to: 'self.class'

          before_update :track_update if options[:track_update]
          before_create :track_create if options[:track_create]
          before_destroy :track_destroy if options[:track_destroy]

          Mongoid::History.trackable_class_options ||= {}
          Mongoid::History.trackable_class_options[options_parser.scope] = options
        end
      end
    end
  end
end

module HistoryTrackerPatch
  extend ActiveSupport::Concern
  included do
    _validators[:modifier].select! do |v|
      !v.is_a?( Mongoid::Validatable::PresenceValidator)
    end
    _validators.delete(:modifier) if _validators[:modifier].blank?
    belongs_to :modifier, class_name: Mongoid::History.modifier_class_name, required: false, optional: true, autosave: false
  end
end


module TrackablePatch
  extend ActiveSupport::Concern
  include Mongoid::History::Trackable
  include Mongoid::Userstamp

  included do

    HistoryTracker.send(:include, HistoryTrackerPatch)

    track_history({
      on: :fields,
      track_create: true,
      track_destroy: true,
      track_update: true,
      modifier_field: :updater,
      except: ["created_at", "updated_at", "c_at", "u_at"],
    })
  end
end
