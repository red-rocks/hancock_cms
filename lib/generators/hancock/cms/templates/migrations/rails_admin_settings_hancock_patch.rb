class RailsAdminSettingsHancockPatch < ActiveRecord::Migration[5.1]
  def change
    change_table :rails_admin_settings do |t|
      t.boolean :for_admin, default: false
    end
  end
end
