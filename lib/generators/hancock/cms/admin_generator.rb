# shamelessly stolen from https://github.com/sferik/rails_admin/blob/master/lib/generators/rails_admin/utils.rb

require 'rails/generators'
require File.expand_path('../utils', __FILE__)

module Hancock::Cms
  class AdminGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    include Generators::Utils::InstanceMethods

    #argument :_namespace, type: :string, required: false, desc: 'RailsAdmin url namespace'
    desc 'Hancock CMS RailsAdmin config generator'

    def install
      #namespace = ask_for('Where do you want to mount rails_admin?', 'admin', _namespace)
      # namespace = 'admin'
      # route("mount RailsAdmin::Engine => '/#{namespace}', as: 'rails_admin'")
      template 'admin.erb', 'config/initializers/rails_admin.rb'
    end
  end
end
