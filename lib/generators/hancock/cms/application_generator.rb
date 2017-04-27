require 'rails/generators'

module Hancock::Cms
  class ApplicationGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :app_name,   type: :string

    desc 'Hancock CMS application.rb generator'
    def install
      template "application.erb", "config/application.rb"
    end
    
  end
end
