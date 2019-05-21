module Hancock::ControllerSettings
  extend ActiveSupport::Concern

  included do
    include Hancock::SettingsHelper
  end
end