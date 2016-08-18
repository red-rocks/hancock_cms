require 'rails/generators'

module Hancock::Cms
  class RackGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc 'Hancock CMS Rack generator'
    def install
      template('rack.erb', 'config/initializers/rack.rb')
    end
  end
end
