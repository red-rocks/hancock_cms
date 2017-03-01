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
  end

end
