require 'rails/generators'

module Hancock::Cms
  class ConfigGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Hancock CMS Config generator'
    def install
      template 'hancock_cms.erb', "config/initializers/hancock_cms.rb"
    end

  end
end
