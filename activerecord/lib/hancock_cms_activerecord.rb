require 'awesome_nested_set'
require 'paper_trail'
require 'friendly_id'
require 'validates_lengths_from_database'
require 'activerecord-session_store'

require 'kaminari'

module Hancock
  def self.orm
    :active_record
  end
end

require 'hancock_cms'
