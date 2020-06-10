module Hancock::Settingable
end
if Hancock.config.model_settings_support
  module Hancock::Settingable
    extend ActiveSupport::Concern

    include RailsAdminModelSettings::ModelSettingable
    include RailsAdminModelSettings::Settingable

    included do
    end


    class_methods do
    end

  end

end
