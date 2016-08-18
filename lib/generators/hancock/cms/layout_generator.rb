require 'rails/generators'
require File.expand_path('../utils', __FILE__)

module Hancock::Cms
  class LayoutGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../..", __FILE__)
    include Generators::Utils::InstanceMethods

    desc 'Hancock CMS Layout generator'
    def layout
      template('../app/views/layouts/application.html.slim', 'app/views/layouts/application.html.slim')
    end
  end
end
