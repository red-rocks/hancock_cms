require 'rails/generators'

module Hancock::Cms
  class RavenGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Hancock CMS Raven Config generator'
    def install
      template 'raven.erb', "config/initializers/raven.rb"
    end

  end
end
