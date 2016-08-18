require 'mongoid'
require 'rails_admin_sort_embedded'
require 'glebtv-mongoid_nested_set'
require 'mongoid-audit'
require 'mongoid_slug'
require 'mongo_session_store-rails4'

module Hancock
  def self.orm
    :mongoid
  end
end

require 'hancock_cms'
