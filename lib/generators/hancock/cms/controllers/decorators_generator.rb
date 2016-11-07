require 'rails/generators'

module Hancock::Cms
  module Controllers
    class DecoratorsGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../../../app/controllers/concerns/hancock/decorators', __FILE__)
      argument :controllers, type: :array, default: []

      desc 'Hancock::Cms Controllers decorators generator'
      def decorators
        copied = false
        (controllers == ['all'] ? permitted_controllers : controllers & permitted_controllers).each do |c|
          copied = true
          copy_file "#{c}.rb", "app/controllers/concerns/hancock/decorators/#{c}.rb"
        end
        puts "U need to set controller`s name. One of this: #{permitted_controllers.join(", ")} or `all`." unless copied
      end

      private
      def permitted_controllers
        ['home', 'sessions', 'registrations']
      end

    end
  end
end
