# TODO remove
require 'rails/generators'

module Hancock::Cms
  class GemfileGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Hancock CMS Gemfile generator'
    def install
      template 'Gemfile.erb', "Gemfile"
    end

  end
end
