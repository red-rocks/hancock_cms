require 'rails/generators'

module Hancock::Cms
  class ScriptsGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates/scripts', __FILE__)

    argument :app_name,   type: :string

    desc 'Hancock CMS scripts generator'
    def install
      %w( assets_precompile.sh
          bundle_production.sh
          full_assets_precompile.sh
          restart_thru_kill.sh
          send_usr2.sh
          send_hup.sh
          db_dump.sh.erb
          db_restore.sh
      ).each do |template_name|
        script_name = template_name.match(/.+\.sh/)[0]
        template template_name, "scripts/#{script_name}"
      end
    end
  end
end
